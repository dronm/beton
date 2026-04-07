package service

import (
	"context"
	"fmt"
	"log/slog"

	"github.com/jackc/pgx/v5/pgxpool"

	"max-webhook/internal/config"
)

type Service struct {
	pool   *pgxpool.Pool
	logger *slog.Logger
	cfg    config.Config
}

func New(pool *pgxpool.Pool, logger *slog.Logger, cfg config.Config) *Service {
	return &Service{
		pool:   pool,
		logger: logger,
		cfg:    cfg,
	}
}

func (s *Service) ProcessUpdate(ctx context.Context, raw []byte) error {
	update, err := parseUpdate(raw)
	if err != nil {
		return err
	}

	switch update.UpdateType {
	case "bot_started":
		return s.handleBotStarted(ctx, update, raw)
	case "message_created":
		return s.handleMessageCreated(ctx, update)
	default:
		s.logger.Info("update skipped", slog.String("update_type", update.UpdateType))
		return nil
	}
}

func (s *Service) beginTx(ctx context.Context) (pgxTx, error) {
	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return nil, fmt.Errorf("begin tx: %w", err)
	}

	return tx, nil
}
