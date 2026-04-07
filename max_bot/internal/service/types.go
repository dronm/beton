package service

import (
	"encoding/json"
	"fmt"
)

type UpdateEnvelope struct {
	UpdateType string          `json:"update_type"`
	Timestamp  int64           `json:"timestamp"`
	ChatID     *int64          `json:"chat_id,omitempty"`
	Payload    *string         `json:"payload,omitempty"`
	UserLocale *string         `json:"user_locale,omitempty"`
	UserRaw    json.RawMessage `json:"user,omitempty"`
	MessageRaw json.RawMessage `json:"message,omitempty"`
}

type User struct {
	UserID        int64   `json:"user_id"`
	FirstName     string  `json:"first_name"`
	LastName      *string `json:"last_name,omitempty"`
	Username      *string `json:"username,omitempty"`
	IsBot         bool    `json:"is_bot"`
	LastActivity  *int64  `json:"last_activity_time,omitempty"`
	Name          *string `json:"name,omitempty"`
	Description   *string `json:"description,omitempty"`
	AvatarURL     *string `json:"avatar_url,omitempty"`
	FullAvatarURL *string `json:"full_avatar_url,omitempty"`
}

type Message struct {
	Sender    *User        `json:"sender,omitempty"`
	Recipient *Recipient   `json:"recipient,omitempty"`
	Timestamp int64        `json:"timestamp"`
	Body      *MessageBody `json:"body,omitempty"`
}

type Recipient struct {
	ChatID *int64 `json:"chat_id,omitempty"`
	UserID *int64 `json:"user_id,omitempty"`
}

type MessageBody struct {
	Text        *string      `json:"text,omitempty"`
	Attachments []Attachment `json:"attachments,omitempty"`
}

type Attachment struct {
	Type    string          `json:"type"`
	Payload json.RawMessage `json:"payload,omitempty"`
}

type contactPayload struct {
	Phone    *string `json:"phone,omitempty"`
	Tel      *string `json:"tel,omitempty"`
	VCFPhone *string `json:"vcf_phone,omitempty"`
	VCFInfo  *string `json:"vcf_info,omitempty"`
}

type activationRow struct {
	ID        int64
	ContactID *int64
	Used      bool
	Expired   bool
}

func parseUpdate(raw []byte) (UpdateEnvelope, error) {
	var update UpdateEnvelope
	if err := json.Unmarshal(raw, &update); err != nil {
		return UpdateEnvelope{}, fmt.Errorf("decode update: %w", err)
	}
	return update, nil
}

func parseUser(raw json.RawMessage) (*User, error) {
	if len(raw) == 0 {
		return nil, nil
	}

	var user User
	if err := json.Unmarshal(raw, &user); err != nil {
		return nil, fmt.Errorf("decode user: %w", err)
	}

	return &user, nil
}

func parseMessage(raw json.RawMessage) (*Message, error) {
	if len(raw) == 0 {
		return nil, nil
	}

	var message Message
	if err := json.Unmarshal(raw, &message); err != nil {
		return nil, fmt.Errorf("decode message: %w", err)
	}

	return &message, nil
}

func hasPhotoFields(raw json.RawMessage) bool {
	if len(raw) == 0 {
		return false
	}

	var payload map[string]json.RawMessage
	if err := json.Unmarshal(raw, &payload); err != nil {
		return false
	}

	if _, ok := payload["avatar_url"]; ok {
		return true
	}
	if _, ok := payload["full_avatar_url"]; ok {
		return true
	}
	if _, ok := payload["description"]; ok {
		return true
	}

	return false
}
