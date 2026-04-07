package service

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"strings"
)

const (
	replyBindOK        = "Ваш аккаунт MAX успешно привязан."
	replyBindInvalid   = "Код активации недействителен. Запросите новую ссылку."
	replyBindExpired   = "Срок действия кода истёк. Запросите новую ссылку."
	replyBindUsed      = "Этот код уже был использован."
	replyNeedBind      = "Чтобы привязать ваш аккаунт MAX, пожалуйста, отправьте свой номер телефона кнопкой ниже."
	replyPhoneNotFound = "Мы получили ваш номер, но не нашли его в базе контактов. Обратитесь в офис."
	replyStartWithSMS  = "Для привязки откройте ссылку из SMS с кодом активации."
)

func (s *Service) handleBotStarted(ctx context.Context, update UpdateEnvelope, rawUpdate []byte) error {
	user, err := parseUser(update.UserRaw)
	if err != nil {
		return err
	}
	if user == nil || user.UserID <= 0 {
		return fmt.Errorf("bot_started has no valid user")
	}
	if update.ChatID == nil || *update.ChatID <= 0 {
		return fmt.Errorf("bot_started has no valid chat_id")
	}

	token := ""
	if update.Payload != nil {
		token = strings.TrimSpace(*update.Payload)
	}

	tx, err := s.beginTx(ctx)
	if err != nil {
		return err
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	if token == "" {
		if err := s.upsertMaxUser(ctx, tx, user, update.UserRaw, nil); err != nil {
			return err
		}
		if err := s.queueOutgoingText(ctx, tx, *update.ChatID, nil, replyStartWithSMS); err != nil {
			return err
		}
		return tx.Commit(ctx)
	}

	activation, err := s.getActivationForUpdate(ctx, tx, token)
	if err != nil {
		return err
	}

	if activation == nil {
		if err := s.upsertMaxUser(ctx, tx, user, update.UserRaw, nil); err != nil {
			return err
		}
		if err := s.queueOutgoingText(ctx, tx, *update.ChatID, nil, replyBindInvalid); err != nil {
			return err
		}
		return tx.Commit(ctx)
	}

	contactID := activation.ContactID

	if activation.Used {
		if err := s.upsertMaxUser(ctx, tx, user, update.UserRaw, contactID); err != nil {
			return err
		}
		if err := s.queueOutgoingText(ctx, tx, *update.ChatID, contactID, replyBindUsed); err != nil {
			return err
		}
		return tx.Commit(ctx)
	}

	if activation.Expired {
		if err := s.upsertMaxUser(ctx, tx, user, update.UserRaw, contactID); err != nil {
			return err
		}
		if err := s.queueOutgoingText(ctx, tx, *update.ChatID, contactID, replyBindExpired); err != nil {
			return err
		}
		return tx.Commit(ctx)
	}

	if err := s.upsertMaxUser(ctx, tx, user, update.UserRaw, contactID); err != nil {
		return err
	}

	if err := s.updateActivationAsUsed(ctx, tx, activation.ID, user.UserID, *update.ChatID, rawUpdate); err != nil {
		return err
	}

	if err := s.queueOutgoingText(ctx, tx, *update.ChatID, contactID, replyBindOK); err != nil {
		return err
	}

	if err := tx.Commit(ctx); err != nil {
		return err
	}

	s.logger.Info("user bound by bot_started",
		slog.Int64("max_user_id", user.UserID),
		slog.Int64("chat_id", *update.ChatID),
		slog.Any("contact_id", contactID),
	)

	return nil
}

func (s *Service) handleMessageCreated(ctx context.Context, update UpdateEnvelope) error {
	message, err := parseMessage(update.MessageRaw)
	if err != nil {
		return err
	}
	if message == nil || message.Sender == nil || message.Sender.UserID <= 0 {
		return nil
	}

	chatID := extractChatID(update, message)
	text := extractMessageText(message)
	sharedPhone := extractSharedPhoneFromMessage(message)

	tx, err := s.beginTx(ctx)
	if err != nil {
		return err
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	if err := s.upsertMaxUser(ctx, tx, message.Sender, updateSenderRaw(message), nil); err != nil {
		return err
	}

	contactID, err := s.getExistingContactID(ctx, tx, message.Sender.UserID)
	if err != nil {
		return err
	}

	if contactID == nil && sharedPhone != nil {
		foundContactID, err := s.findContactIDByPhone(ctx, tx, *sharedPhone)
		if err != nil {
			return err
		}

		if foundContactID != nil {
			if err := s.upsertMaxUser(ctx, tx, message.Sender, updateSenderRaw(message), foundContactID); err != nil {
				return err
			}
			contactID = foundContactID

			if chatID != nil {
				if err := s.queueOutgoingText(ctx, tx, *chatID, contactID, replyBindOK); err != nil {
					return err
				}
			}
		} else if chatID != nil {
			if err := s.queueOutgoingText(ctx, tx, *chatID, nil, replyPhoneNotFound); err != nil {
				return err
			}
		}
	}

	if err := s.insertIncomingMessage(ctx, tx, update.MessageRaw, contactID); err != nil {
		return err
	}

	if contactID == nil && sharedPhone == nil && chatID != nil {
		if err := s.queueOutgoingRequestContact(ctx, tx, *chatID, nil, replyNeedBind, "Поделиться телефоном"); err != nil {
			return err
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return err
	}

	s.logger.Info("message stored",
		slog.Int64("max_user_id", message.Sender.UserID),
		slog.Any("chat_id", chatID),
		slog.Bool("has_contact_id", contactID != nil),
		slog.Any("shared_phone", sharedPhone),
		slog.String("text", text),
	)

	return nil
}

func updateSenderRaw(message *Message) []byte {
	if message == nil || message.Sender == nil {
		return nil
	}

	raw, _ := json.Marshal(message.Sender)
	return raw
}
