package config

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

type Config struct {
	ListenAddr        string
	DatabaseURL       string
	MaxBotToken       string
	MaxAPIBase        string
	WebhookURL        string
	WebhookSecret     string
	RegisterWebhook   bool
	AppID             int64
	ReadHeaderTimeout time.Duration
	HTTPClientTimeout time.Duration
	ShutdownTimeout   time.Duration
}

func Load() (Config, error) {
	cfg := Config{
		ListenAddr:        getEnvDefault("LISTEN_ADDR", ":8080"),
		DatabaseURL:       strings.TrimSpace(os.Getenv("DATABASE_URL")),
		MaxBotToken:       strings.TrimSpace(os.Getenv("MAX_BOT_TOKEN")),
		MaxAPIBase:        getEnvDefault("MAX_API_BASE", "https://platform-api.max.ru"),
		WebhookURL:        strings.TrimSpace(os.Getenv("MAX_WEBHOOK_URL")),
		WebhookSecret:     strings.TrimSpace(os.Getenv("MAX_WEBHOOK_SECRET")),
		RegisterWebhook:   getEnvBoolDefault("MAX_REGISTER_WEBHOOK", true),
		ReadHeaderTimeout: getEnvDurationDefault("READ_HEADER_TIMEOUT", 10*time.Second),
		HTTPClientTimeout: getEnvDurationDefault("HTTP_CLIENT_TIMEOUT", 30*time.Second),
		ShutdownTimeout:   getEnvDurationDefault("SHUTDOWN_TIMEOUT", 10*time.Second),
	}

	appIDRaw := strings.TrimSpace(os.Getenv("MAX_APP_ID"))
	if appIDRaw == "" {
		appIDRaw = strings.TrimSpace(os.Getenv("MS_APP_ID"))
	}
	if appIDRaw == "" {
		return Config{}, fmt.Errorf("MAX_APP_ID or MS_APP_ID is required")
	}

	appID, err := strconv.ParseInt(appIDRaw, 10, 64)
	if err != nil {
		return Config{}, fmt.Errorf("parse MAX_APP_ID/MS_APP_ID: %w", err)
	}
	cfg.AppID = appID

	if cfg.DatabaseURL == "" {
		return Config{}, fmt.Errorf("DATABASE_URL is required")
	}
	if cfg.MaxBotToken == "" {
		return Config{}, fmt.Errorf("MAX_BOT_TOKEN is required")
	}
	if cfg.RegisterWebhook && cfg.WebhookURL == "" {
		return Config{}, fmt.Errorf("MAX_WEBHOOK_URL is required when MAX_REGISTER_WEBHOOK=true")
	}

	return cfg, nil
}

func getEnvDefault(key string, fallback string) string {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback
	}
	return value
}

func getEnvBoolDefault(key string, fallback bool) bool {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback
	}

	parsed, err := strconv.ParseBool(value)
	if err != nil {
		return fallback
	}

	return parsed
}

func getEnvDurationDefault(key string, fallback time.Duration) time.Duration {
	value := strings.TrimSpace(os.Getenv(key))
	if value == "" {
		return fallback
	}

	parsed, err := time.ParseDuration(value)
	if err != nil {
		return fallback
	}

	return parsed
}
