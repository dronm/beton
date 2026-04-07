package httpserver

import (
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"strings"

	"max-webhook/internal/config"
	"max-webhook/internal/service"
)

type Logger interface {
	Info(msg string, args ...any)
	Warn(msg string, args ...any)
	Error(msg string, args ...any)
}

func NewHandler(cfg config.Config, logger Logger, svc *service.Service) http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"ok": true,
		})
	})

	mux.HandleFunc("/webhook/max", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, http.StatusText(http.StatusMethodNotAllowed), http.StatusMethodNotAllowed)
			return
		}

		if cfg.WebhookSecret != "" {
			secret := strings.TrimSpace(r.Header.Get("X-Max-Bot-Api-Secret"))
			if secret != cfg.WebhookSecret {
				logger.Warn("webhook secret mismatch", slog.String("remote_addr", r.RemoteAddr))
				http.Error(w, http.StatusText(http.StatusUnauthorized), http.StatusUnauthorized)
				return
			}
		}

		body, err := io.ReadAll(r.Body)
		if err != nil {
			logger.Error("read webhook body", slog.Any("error", err))
			http.Error(w, http.StatusText(http.StatusBadRequest), http.StatusBadRequest)
			return
		}

		if err := svc.ProcessUpdate(r.Context(), body); err != nil {
			logger.Error("process update", slog.Any("error", err))
			http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusOK)
	})

	return mux
}
