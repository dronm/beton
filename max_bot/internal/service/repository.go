package service

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

type pgxTx interface {
	Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error)
	QueryRow(ctx context.Context, sql string, args ...any) pgx.Row
	Rollback(ctx context.Context) error
	Commit(ctx context.Context) error
}

func (s *Service) getExistingContactID(ctx context.Context, tx pgxTx, maxUserID int64) (*int64, error) {
	var contactID *int64

	err := tx.QueryRow(ctx, `
		SELECT contact_id
		FROM notifications.max_users
		WHERE max_user_id = $1
		LIMIT 1
	`, maxUserID).Scan(&contactID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("select max user: %w", err)
	}

	return contactID, nil
}

func (s *Service) upsertMaxUser(ctx context.Context, tx pgxTx, user *User, rawUser json.RawMessage, contactID *int64) error {
	if user == nil || user.UserID <= 0 {
		return fmt.Errorf("invalid MAX user_id")
	}

	username := nullableString(user.Username)
	avatarURL := nullableString(user.AvatarURL)
	var rawUserWithPhoto *string

	if hasPhotoFields(rawUser) {
		encoded := string(rawUser)
		rawUserWithPhoto = &encoded
	}

	_, err := tx.Exec(ctx, `
		SELECT notifications.upsert_max_user(
			$1,
			$2,
			$3,
			$4::jsonb,
			$5::jsonb,
			$6
		)
	`, user.UserID, username, avatarURL, string(rawUser), rawUserWithPhoto, contactID)
	if err != nil {
		return fmt.Errorf("call notifications.upsert_max_user: %w", err)
	}

	return nil
}

func (s *Service) insertIncomingMessage(ctx context.Context, tx pgxTx, rawMessage json.RawMessage, contactID *int64) error {
	_, err := tx.Exec(ctx, `
		INSERT INTO notifications.max_in_messages_write (
			message,
			contact_id,
			app_id
		)
		VALUES (
			$1::jsonb,
			$2,
			$3
		)
	`, string(rawMessage), contactID, s.cfg.AppID)
	if err != nil {
		return fmt.Errorf("insert incoming message: %w", err)
	}

	return nil
}

func (s *Service) queueOutgoingText(ctx context.Context, tx pgxTx, chatID int64, contactID *int64, text string) error {
	payload, err := json.Marshal(map[string]any{
		"text": text,
	})
	if err != nil {
		return fmt.Errorf("encode outgoing text: %w", err)
	}

	return s.insertOutgoingMessage(ctx, tx, payload, chatID, contactID)
}

func (s *Service) queueOutgoingRequestContact(ctx context.Context, tx pgxTx, chatID int64, contactID *int64, text string, buttonText string) error {
	payload, err := json.Marshal(map[string]any{
		"text": text,
		"attachments": []any{
			map[string]any{
				"type": "inline_keyboard",
				"payload": map[string]any{
					"buttons": []any{
						[]any{
							map[string]any{
								"type": "request_contact",
								"text": buttonText,
							},
						},
					},
				},
			},
		},
	})
	if err != nil {
		return fmt.Errorf("encode outgoing request_contact: %w", err)
	}

	return s.insertOutgoingMessage(ctx, tx, payload, chatID, contactID)
}

func (s *Service) insertOutgoingMessage(ctx context.Context, tx pgxTx, payload []byte, chatID int64, contactID *int64) error {
	_, err := tx.Exec(ctx, `
		INSERT INTO notifications.max_out_messages_write (
			message,
			max_chat_id,
			contact_id,
			app_id
		)
		VALUES (
			$1::jsonb,
			$2,
			$3,
			$4
		)
	`, string(payload), chatID, contactID, s.cfg.AppID)
	if err != nil {
		return fmt.Errorf("insert outgoing message: %w", err)
	}

	return nil
}

func (s *Service) findContactIDByPhone(ctx context.Context, tx pgxTx, phone string) (*int64, error) {
	if strings.HasPrefix(phone, "7") {
		phone = phone[1:]
	}

	var contactID int64
	err := tx.QueryRow(ctx, `
		SELECT id
		FROM public.contacts
		WHERE tel = $1
		LIMIT 1
	`, phone).Scan(&contactID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("find contact by phone: %w", err)
	}

	return &contactID, nil
}

func nullableString(value *string) *string {
	if value == nil {
		return nil
	}

	trimmed := strings.TrimSpace(*value)
	if trimmed == "" {
		return nil
	}

	return &trimmed
}
