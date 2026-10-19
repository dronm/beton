package service

import (
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
)

const (
	replyBindOK        = "Ваш аккаунт MAX успешно привязан."
	replyAlreadyBound  = "Ваш аккаунт MAX уже привязан."
	replyNeedBind      = "Чтобы привязать ваш аккаунт MAX, пожалуйста, отправьте свой номер телефона кнопкой ниже."
	replyPhoneNotFound = "Мы получили ваш номер, но не нашли его в базе контактов. Обратитесь в офис."
	sharePhoneButton   = "Поделиться телефоном"
)

func (s *Service) handleBotStarted(ctx context.Context, update UpdateEnvelope) error {
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

	tx, err := s.beginTx(ctx)
	if err != nil {
		return err
	}
	defer func() {
		_ = tx.Rollback(ctx)
	}()

	// A MAX profile alone is not a registration: it must have a contact_id.
	// Read the link before refreshing the profile, and preserve it on upsert.
	contactID, err := s.getExistingContactID(ctx, tx, user.UserID)
	if err != nil {
		return err
	}
	if err := s.upsertMaxUser(ctx, tx, user, update.UserRaw, contactID); err != nil {
		return err
	}

	// Activation/SMS payloads no longer participate in account linking.
	if contactID == nil {
		if err := s.queueOutgoingRequestContact(ctx, tx, *update.ChatID, nil, replyNeedBind, sharePhoneButton); err != nil {
			return err
		}
	} else {
		if err := s.queueOutgoingText(ctx, tx, *update.ChatID, contactID, replyAlreadyBound); err != nil {
			return err
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return err
	}

	s.logger.Info("bot started",
		slog.Int64("max_user_id", user.UserID),
		slog.Int64("chat_id", *update.ChatID),
		slog.Bool("has_contact_id", contactID != nil),
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

	contactID, err := s.getExistingContactID(ctx, tx, message.Sender.UserID)
	if err != nil {
		return err
	}

	if err := s.upsertMaxUser(ctx, tx, message.Sender, updateSenderRaw(message), contactID); err != nil {
		return err
	}

	prompt := replyNeedBind
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
		} else {
			prompt = replyPhoneNotFound + "\n\n" + replyNeedBind
		}
	}

	if err := s.insertIncomingMessage(ctx, tx, update.MessageRaw, contactID); err != nil {
		return err
	}

	// Prompt on every message while there is no linked contact, including
	// /start and a shared phone that was not found in the contacts database.
	if contactID == nil && chatID != nil {
		if err := s.queueOutgoingRequestContact(ctx, tx, *chatID, nil, prompt, sharePhoneButton); err != nil {
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
