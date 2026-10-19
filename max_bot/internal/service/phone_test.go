package service

import (
	"encoding/json"
	"testing"
)

func TestNormalizePhone(t *testing.T) {
	for _, tc := range []struct {
		name  string
		input *string
		want  *string
	}{
		{name: "nil"},
		{name: "blank", input: stringPtr("  ")},
		{name: "no digits", input: stringPtr("not a phone")},
		{name: "too short", input: stringPtr("12345")},
		{name: "too long", input: stringPtr("1234567890123456")},
		{name: "Russian formatted", input: stringPtr("+7 (999) 000-00-00"), want: stringPtr("79990000000")},
		{name: "Russian domestic prefix", input: stringPtr("8 (999) 000-00-00"), want: stringPtr("79990000000")},
		{name: "Russian local", input: stringPtr("9990000000"), want: stringPtr("79990000000")},
		{name: "international", input: stringPtr("+44 20 7946 0000"), want: stringPtr("442079460000")},
	} {
		t.Run(tc.name, func(t *testing.T) {
			assertPhone(t, normalizePhone(tc.input), tc.want)
		})
	}
}

func TestExtractSharedPhoneFromMessage(t *testing.T) {
	for _, tc := range []struct {
		name    string
		message *Message
		want    *string
	}{
		{name: "nil message"},
		{name: "missing body", message: &Message{}},
		{name: "typed phone is not a contact", message: &Message{Body: &MessageBody{Text: stringPtr("+7 999 000 00 00")}}},
		{name: "phone field", message: phoneTestMessage("contact", `{"phone":"+7 (999) 000-00-00"}`), want: stringPtr("79990000000")},
		{name: "tel field", message: phoneTestMessage("contact", `{"tel":"89990000000"}`), want: stringPtr("79990000000")},
		{name: "vcf_phone field", message: phoneTestMessage("contact", `{"vcf_phone":"9990000000"}`), want: stringPtr("79990000000")},
		{name: "MAX vCard CRLF", message: phoneTestMessage("contact", `{"vcf_info":"BEGIN:VCARD\r\nVERSION:3.0\r\nTEL;TYPE=cell:79990000000\r\nEND:VCARD\r\n"}`), want: stringPtr("79990000000")},
		{name: "vCard LF", message: phoneTestMessage("contact", `{"vcf_info":"BEGIN:VCARD\nTEL:+7 999 000 00 00\nEND:VCARD"}`), want: stringPtr("79990000000")},
		{name: "vCard tel URI", message: phoneTestMessage("contact", `{"vcf_info":"BEGIN:VCARD\nTEL;VALUE=uri:tel:+7-999-000-00-00\nEND:VCARD"}`), want: stringPtr("79990000000")},
		{name: "no phone in contact", message: phoneTestMessage("contact", `{"vcf_info":"BEGIN:VCARD\nFN:Test user\nEND:VCARD"}`)},
		{name: "invalid phone", message: phoneTestMessage("contact", `{"phone":"invalid"}`)},
		{name: "invalid contact JSON", message: phoneTestMessage("contact", `{`)},
		{name: "other attachment", message: phoneTestMessage("image", `{"phone":"79990000000"}`)},
	} {
		t.Run(tc.name, func(t *testing.T) {
			assertPhone(t, extractSharedPhoneFromMessage(tc.message), tc.want)
		})
	}
}

func phoneTestMessage(attachmentType string, payload string) *Message {
	return &Message{Body: &MessageBody{Attachments: []Attachment{{
		Type:    attachmentType,
		Payload: json.RawMessage(payload),
	}}}}
}

func assertPhone(t *testing.T, actual *string, expected *string) {
	t.Helper()
	if expected == nil {
		if actual != nil {
			t.Fatalf("phone = %q, want nil", *actual)
		}
		return
	}
	if actual == nil {
		t.Fatalf("phone = nil, want %q", *expected)
	}
	if *actual != *expected {
		t.Fatalf("phone = %q, want %q", *actual, *expected)
	}
}
