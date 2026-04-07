package service

import (
	"encoding/json"
	"regexp"
	"strings"
)

var phoneDigitsRegexp = regexp.MustCompile(`\D+`)

func extractMessageText(message *Message) string {
	if message == nil || message.Body == nil || message.Body.Text == nil {
		return ""
	}

	return strings.TrimSpace(*message.Body.Text)
}

func extractChatID(update UpdateEnvelope, message *Message) *int64 {
	if update.ChatID != nil && *update.ChatID > 0 {
		return update.ChatID
	}

	if message != nil && message.Recipient != nil && message.Recipient.ChatID != nil && *message.Recipient.ChatID > 0 {
		return message.Recipient.ChatID
	}

	if message != nil && message.Sender != nil && message.Sender.UserID > 0 {
		chatID := message.Sender.UserID
		return &chatID
	}

	return nil
}

func extractSharedPhoneFromMessage(message *Message) *string {
	if message == nil || message.Body == nil {
		return nil
	}

	for _, attachment := range message.Body.Attachments {
		if attachment.Type != "contact" {
			continue
		}

		var payload contactPayload
		if err := json.Unmarshal(attachment.Payload, &payload); err != nil {
			continue
		}

		for _, candidate := range []*string{payload.Phone, payload.Tel, payload.VCFPhone} {
			phone := normalizePhone(candidate)
			if phone != nil {
				return phone
			}
		}

		if payload.VCFInfo != nil {
			phone := extractPhoneFromVCF(*payload.VCFInfo)
			if phone != nil {
				return phone
			}
		}
	}

	return nil
}

func extractPhoneFromVCF(vcfInfo string) *string {
	lines := strings.FieldsFunc(vcfInfo, func(r rune) bool {
		return r == '\r' || r == '\n'
	})

	for _, line := range lines {
		line = strings.TrimSpace(line)
		if !strings.HasPrefix(strings.ToUpper(line), "TEL") {
			continue
		}

		pos := strings.LastIndex(line, ":")
		if pos < 0 || pos+1 >= len(line) {
			continue
		}

		phone := normalizePhone(stringPtr(line[pos+1:]))
		if phone != nil {
			return phone
		}
	}

	return nil
}

func normalizePhone(phone *string) *string {
	if phone == nil {
		return nil
	}

	trimmed := strings.TrimSpace(*phone)
	if trimmed == "" {
		return nil
	}

	digits := phoneDigitsRegexp.ReplaceAllString(trimmed, "")
	if digits == "" {
		return nil
	}

	switch {
	case len(digits) == 10:
		digits = "7" + digits
	case len(digits) == 11 && digits[0] == '8':
		digits = "7" + digits[1:]
	}

	if len(digits) < 10 || len(digits) > 15 {
		return nil
	}

	return stringPtr(digits)
}

func stringPtr(value string) *string {
	return &value
}
