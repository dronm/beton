package httpserver

import (
	"net/http"

	"max-webhook/internal/config"
	"max-webhook/internal/service"
)

func New(cfg config.Config, logger Logger, svc *service.Service) *http.Server {
	handler := NewHandler(cfg, logger, svc)

	return &http.Server{
		Addr:              cfg.ListenAddr,
		Handler:           handler,
		ReadHeaderTimeout: cfg.ReadHeaderTimeout,
	}
}
