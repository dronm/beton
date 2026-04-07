package main

import (
	"context"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"max-webhook/internal/config"
	"max-webhook/internal/db"
	"max-webhook/internal/httpserver"
	"max-webhook/internal/maxapi"
	"max-webhook/internal/service"
)

var (
	version = "dev"
	commit = "none"
	buildTime = ""
)

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{}))

	cfg, err := config.Load()
	if err != nil {
		logger.Error("load config", slog.Any("error", err))
		os.Exit(1)
	}

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	pool, err := db.NewPool(ctx, cfg.DatabaseURL)
	if err != nil {
		logger.Error("connect database", slog.Any("error", err))
		os.Exit(1)
	}
	defer pool.Close()

	svc := service.New(pool, logger, cfg)
	apiClient := maxapi.New(cfg.MaxBotToken, cfg.MaxAPIBase, cfg.HTTPClientTimeout)

	if cfg.RegisterWebhook {
		if err := apiClient.RegisterWebhook(ctx, cfg.WebhookURL, []string{"message_created", "bot_started"}, cfg.WebhookSecret); err != nil {
			logger.Error("register webhook", slog.Any("error", err))
			os.Exit(1)
		}

		logger.Info("webhook registered", slog.String("url", cfg.WebhookURL))
	}

	server := httpserver.New(cfg, logger, svc)

	go func() {
		<-ctx.Done()

		shutdownCtx, cancel := context.WithTimeout(context.Background(), cfg.ShutdownTimeout)
		defer cancel()

		if err := server.Shutdown(shutdownCtx); err != nil {
			logger.Error("shutdown http server", slog.Any("error", err))
		}
	}()

	logger.Info("starting http server", slog.String("addr", cfg.ListenAddr))

	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		logger.Error("http server failed", slog.Any("error", err))
		os.Exit(1)
	}
}
