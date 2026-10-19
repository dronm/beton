package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"reflect"
	"strings"
	"testing"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"

	"max-webhook/internal/config"
)

const (
	testUserID int64 = 12345
	testChatID int64 = 67890
	testAppID  int64 = 42
)

func TestBotStartedUsesContactLink(t *testing.T) {
	for _, user := range []struct {
		name      string
		exists    bool
		contactID *int64
	}{
		{name: "missing max_users row"},
		{name: "existing row with NULL contact_id", exists: true},
		{name: "existing linked contact", exists: true, contactID: int64Ptr(71)},
	} {
		for _, payload := range []struct {
			name  string
			value *string
		}{
			{name: "no payload"},
			{name: "empty payload", value: stringPtr("")},
			{name: "blank payload", value: stringPtr("  ")},
			{name: "legacy activation payload", value: stringPtr("old-sms-token")},
		} {
			t.Run(user.name+"/"+payload.name, func(t *testing.T) {
				tx := newTestTx(t, startSteps(user.contactID, user.exists)...)
				svc := newTestService(t, tx)

				if err := svc.ProcessUpdate(context.Background(), startedUpdate(t, payload.value)); err != nil {
					t.Fatalf("ProcessUpdate: %v", err)
				}
			})
		}
	}
}

func TestRepeatedBotStartedRechecksContactLink(t *testing.T) {
	// The same user starts twice without a link, is linked externally, then
	// is unlinked externally. Every update must consult the database again.
	transactions := []*testTx{
		newTestTx(t, startSteps(nil, false)...),
		newTestTx(t, startSteps(nil, true)...),
		newTestTx(t, startSteps(int64Ptr(71), true)...),
		newTestTx(t, startSteps(nil, true)...),
	}
	svc := newTestService(t, transactions...)
	raw := startedUpdate(t, nil)

	for attempt := range transactions {
		if err := svc.ProcessUpdate(context.Background(), raw); err != nil {
			t.Fatalf("start %d: %v", attempt+1, err)
		}
	}
}

func TestUnlinkedMessageAlwaysRequestsPhone(t *testing.T) {
	for _, tc := range []struct {
		name        string
		exists      bool
		text        string
		attachments []Attachment
	}{
		{name: "new user start", text: "/start"},
		{name: "existing unlinked user start", exists: true, text: "/start"},
		{name: "legacy start command", exists: true, text: "/start old-sms-token"},
		{name: "ordinary text", exists: true, text: "Hello"},
		{name: "typed number is not shared contact", exists: true, text: "+7 999 000 00 00"},
		{name: "empty message", exists: true},
		{name: "non-contact attachment", exists: true, attachments: []Attachment{
			{Type: "image", Payload: json.RawMessage(`{"url":"https://example.invalid/photo"}`)},
		}},
		{name: "contact without a valid phone", exists: true, attachments: []Attachment{
			{Type: "contact", Payload: json.RawMessage(`{"phone":"invalid"}`)},
		}},
	} {
		t.Run(tc.name, func(t *testing.T) {
			raw, messageRaw := createdUpdate(t, tc.text, tc.attachments...)
			tx := newTestTx(t,
				expectContact(nil, tc.exists),
				expectUpsert(nil),
				expectIncoming(messageRaw, nil),
				expectOutgoing(nil, replyNeedBind, true),
			)
			svc := newTestService(t, tx)

			if err := svc.ProcessUpdate(context.Background(), raw); err != nil {
				t.Fatalf("ProcessUpdate: %v", err)
			}
		})
	}
}

func TestSharedPhoneLinksContactOrRequestsRetry(t *testing.T) {
	for _, tc := range []struct {
		name      string
		exists    bool
		contactID *int64
	}{
		{name: "new user with matching phone", contactID: int64Ptr(71)},
		{name: "existing unlinked user with matching phone", exists: true, contactID: int64Ptr(71)},
		{name: "new user with unmatched phone"},
		{name: "existing unlinked user with unmatched phone", exists: true},
	} {
		t.Run(tc.name, func(t *testing.T) {
			raw, messageRaw := createdUpdate(t, "", sharedContact())
			tx := newTestTx(t, sharedPhoneSteps(messageRaw, tc.exists, tc.contactID)...)
			svc := newTestService(t, tx)

			if err := svc.ProcessUpdate(context.Background(), raw); err != nil {
				t.Fatalf("ProcessUpdate: %v", err)
			}
		})
	}
}

func TestPhoneCanBeRetriedAfterContactIsAdded(t *testing.T) {
	raw, messageRaw := createdUpdate(t, "", sharedContact())
	contactID := int64Ptr(71)
	svc := newTestService(t,
		newTestTx(t, sharedPhoneSteps(messageRaw, true, nil)...),
		newTestTx(t, sharedPhoneSteps(messageRaw, true, contactID)...),
		newTestTx(t, startSteps(contactID, true)...),
	)

	// A failed lookup does not mark the user as registered or suppress retries.
	for attempt := 0; attempt < 2; attempt++ {
		if err := svc.ProcessUpdate(context.Background(), raw); err != nil {
			t.Fatalf("phone attempt %d: %v", attempt+1, err)
		}
	}
	if err := svc.ProcessUpdate(context.Background(), startedUpdate(t, nil)); err != nil {
		t.Fatalf("start after successful linking: %v", err)
	}
}

func TestLinkedMessagePreservesContact(t *testing.T) {
	for _, tc := range []struct {
		name        string
		text        string
		attachments []Attachment
	}{
		{name: "start", text: "/start"},
		{name: "ordinary message", text: "Hello"},
		{name: "shared contact does not relink user", attachments: []Attachment{sharedContact()}},
	} {
		t.Run(tc.name, func(t *testing.T) {
			raw, messageRaw := createdUpdate(t, tc.text, tc.attachments...)
			contactID := int64Ptr(71)
			tx := newTestTx(t,
				expectContact(contactID, true),
				expectUpsert(contactID),
				expectIncoming(messageRaw, contactID),
			)
			svc := newTestService(t, tx)

			if err := svc.ProcessUpdate(context.Background(), raw); err != nil {
				t.Fatalf("ProcessUpdate: %v", err)
			}
		})
	}
}

func TestUpdateRollsBackOnDatabaseErrors(t *testing.T) {
	messageUpdate, messageRaw := createdUpdate(t, "", sharedContact())
	for _, scenario := range []struct {
		name  string
		raw   []byte
		steps []testStep
	}{
		{name: "unlinked start", raw: startedUpdate(t, nil), steps: startSteps(nil, true)},
		{name: "linked start", raw: startedUpdate(t, nil), steps: startSteps(int64Ptr(71), true)},
		{name: "matching phone", raw: messageUpdate, steps: sharedPhoneSteps(messageRaw, true, int64Ptr(71))},
		{name: "unmatched phone", raw: messageUpdate, steps: sharedPhoneSteps(messageRaw, true, nil)},
	} {
		for failureIndex := range scenario.steps {
			t.Run(fmt.Sprintf("%s/step %d", scenario.name, failureIndex+1), func(t *testing.T) {
				failure := errors.New("database unavailable")
				steps := append([]testStep(nil), scenario.steps[:failureIndex+1]...)
				steps[failureIndex].err = failure
				tx := newTestTx(t, steps...)
				tx.wantCommit = false
				svc := newTestService(t, tx)

				if err := svc.ProcessUpdate(context.Background(), scenario.raw); !errors.Is(err, failure) {
					t.Fatalf("ProcessUpdate error = %v, want %v", err, failure)
				}
			})
		}

		t.Run(scenario.name+"/commit", func(t *testing.T) {
			failure := errors.New("commit failed")
			tx := newTestTx(t, scenario.steps...)
			tx.commitErr = failure
			svc := newTestService(t, tx)

			if err := svc.ProcessUpdate(context.Background(), scenario.raw); !errors.Is(err, failure) {
				t.Fatalf("ProcessUpdate error = %v, want %v", err, failure)
			}
		})
	}
}

func TestUpdateReturnsBeginError(t *testing.T) {
	failure := errors.New("pool unavailable")
	svc := &Service{
		beginTransaction: func(context.Context) (pgxTx, error) {
			return nil, failure
		},
		logger: slog.New(slog.NewTextHandler(io.Discard, nil)),
	}
	messageUpdate, _ := createdUpdate(t, "/start")

	for _, raw := range [][]byte{startedUpdate(t, nil), messageUpdate} {
		if err := svc.ProcessUpdate(context.Background(), raw); !errors.Is(err, failure) {
			t.Fatalf("ProcessUpdate error = %v, want %v", err, failure)
		}
	}
}

func TestInvalidBotStartedDoesNotAccessDatabase(t *testing.T) {
	for _, raw := range []string{
		`{`,
		`{"update_type":"bot_started","chat_id":67890}`,
		`{"update_type":"bot_started","chat_id":67890,"user":null}`,
		`{"update_type":"bot_started","chat_id":67890,"user":{"user_id":0}}`,
		`{"update_type":"bot_started","chat_id":67890,"user":{"user_id":"invalid"}}`,
		`{"update_type":"bot_started","user":{"user_id":12345}}`,
		`{"update_type":"bot_started","chat_id":0,"user":{"user_id":12345}}`,
	} {
		t.Run(raw, func(t *testing.T) {
			svc := newTestService(t)
			if err := svc.ProcessUpdate(context.Background(), []byte(raw)); err == nil {
				t.Fatal("ProcessUpdate returned no error for an invalid update")
			}
		})
	}
}

func TestUnsupportedUpdateDoesNotAccessDatabase(t *testing.T) {
	svc := newTestService(t)
	if err := svc.ProcessUpdate(context.Background(), []byte(`{"update_type":"bot_stopped"}`)); err != nil {
		t.Fatalf("ProcessUpdate: %v", err)
	}
}

func startSteps(contactID *int64, exists bool) []testStep {
	text := replyNeedBind
	if contactID != nil {
		text = replyAlreadyBound
	}
	return []testStep{
		expectContact(contactID, exists),
		expectUpsert(contactID),
		expectOutgoing(contactID, text, contactID == nil),
	}
}

func sharedPhoneSteps(messageRaw []byte, exists bool, contactID *int64) []testStep {
	steps := []testStep{
		expectContact(nil, exists),
		expectUpsert(nil),
		expectPhoneLookup("9990000000", contactID),
	}
	if contactID != nil {
		steps = append(steps, expectUpsert(contactID), expectOutgoing(contactID, replyBindOK, false))
	}
	steps = append(steps, expectIncoming(messageRaw, contactID))
	if contactID == nil {
		steps = append(steps, expectOutgoing(nil, replyPhoneNotFound+"\n\n"+replyNeedBind, true))
	}
	return steps
}

func startedUpdate(t *testing.T, payload *string) []byte {
	t.Helper()
	return marshalTestJSON(t, UpdateEnvelope{
		UpdateType: "bot_started",
		ChatID:     int64Ptr(testChatID),
		Payload:    payload,
		UserRaw:    marshalTestJSON(t, User{UserID: testUserID, FirstName: "Test user"}),
	})
}

func createdUpdate(t *testing.T, text string, attachments ...Attachment) ([]byte, []byte) {
	t.Helper()
	messageRaw := marshalTestJSON(t, Message{
		Sender:    &User{UserID: testUserID, FirstName: "Test user"},
		Recipient: &Recipient{ChatID: int64Ptr(testChatID)},
		Body:      &MessageBody{Text: stringPtr(text), Attachments: attachments},
	})
	return marshalTestJSON(t, UpdateEnvelope{
		UpdateType: "message_created",
		MessageRaw: messageRaw,
	}), messageRaw
}

func sharedContact() Attachment {
	return Attachment{
		Type:    "contact",
		Payload: json.RawMessage(`{"vcf_info":"BEGIN:VCARD\r\nVERSION:3.0\r\nTEL;TYPE=cell:+7 (999) 000-00-00\r\nEND:VCARD\r\n"}`),
	}
}

func marshalTestJSON(t *testing.T, value any) []byte {
	t.Helper()
	raw, err := json.Marshal(value)
	if err != nil {
		t.Fatalf("json.Marshal: %v", err)
	}
	return raw
}

func int64Ptr(value int64) *int64 {
	return &value
}

// These strict transaction doubles test the real handlers and repository SQL
// calls without a live database or additional mock dependencies. Unexpected
// token-table queries, repeated replies, or dropped contact IDs fail the test.
type testStep struct {
	query     bool
	sql       string
	values    []any
	err       error
	checkArgs func(*testing.T, []any)
}

type testTx struct {
	t             *testing.T
	steps         []testStep
	nextStep      int
	wantCommit    bool
	commitCalls   int
	rollbackCalls int
	commitErr     error
}

func newTestTx(t *testing.T, steps ...testStep) *testTx {
	t.Helper()
	tx := &testTx{t: t, steps: steps, wantCommit: true}
	t.Cleanup(func() {
		if tx.nextStep != len(tx.steps) {
			t.Errorf("executed %d database steps, want %d", tx.nextStep, len(tx.steps))
		}
		wantCommits := 0
		if tx.wantCommit {
			wantCommits = 1
		}
		if tx.commitCalls != wantCommits {
			t.Errorf("commit calls = %d, want %d", tx.commitCalls, wantCommits)
		}
		if tx.rollbackCalls != 1 {
			t.Errorf("rollback calls = %d, want 1", tx.rollbackCalls)
		}
	})
	return tx
}

func newTestService(t *testing.T, transactions ...*testTx) *Service {
	t.Helper()
	next := 0
	t.Cleanup(func() {
		if next != len(transactions) {
			t.Errorf("transactions started = %d, want %d", next, len(transactions))
		}
	})
	return &Service{
		beginTransaction: func(context.Context) (pgxTx, error) {
			if next >= len(transactions) {
				t.Fatal("unexpected transaction")
			}
			tx := transactions[next]
			next++
			return tx, nil
		},
		logger: slog.New(slog.NewTextHandler(io.Discard, nil)),
		cfg:    config.Config{AppID: testAppID},
	}
}

func (tx *testTx) takeStep(query bool, sql string, args []any) testStep {
	tx.t.Helper()
	if tx.nextStep >= len(tx.steps) {
		tx.t.Fatalf("unexpected database call: %s", sql)
	}
	step := tx.steps[tx.nextStep]
	tx.nextStep++
	if query != step.query || !strings.Contains(strings.Join(strings.Fields(sql), " "), step.sql) {
		tx.t.Fatalf("database step %d: query=%t, sql=%s; want query=%t, sql containing %q", tx.nextStep, query, sql, step.query, step.sql)
	}
	if step.checkArgs != nil {
		step.checkArgs(tx.t, args)
	}
	return step
}

func (tx *testTx) Exec(_ context.Context, sql string, args ...any) (pgconn.CommandTag, error) {
	step := tx.takeStep(false, sql, args)
	return pgconn.CommandTag{}, step.err
}

func (tx *testTx) QueryRow(_ context.Context, sql string, args ...any) pgx.Row {
	step := tx.takeStep(true, sql, args)
	return testRow{values: step.values, err: step.err}
}

func (tx *testTx) Commit(context.Context) error {
	tx.commitCalls++
	return tx.commitErr
}

func (tx *testTx) Rollback(context.Context) error {
	tx.rollbackCalls++
	return nil
}

type testRow struct {
	values []any
	err    error
}

func (row testRow) Scan(dest ...any) error {
	if row.err != nil {
		return row.err
	}
	if len(dest) != len(row.values) {
		return fmt.Errorf("Scan destinations = %d, want %d", len(dest), len(row.values))
	}
	for i, value := range row.values {
		target := reflect.ValueOf(dest[i]).Elem()
		if value == nil {
			target.SetZero()
			continue
		}
		source := reflect.ValueOf(value)
		if !source.Type().AssignableTo(target.Type()) {
			return fmt.Errorf("Scan value %d: cannot assign %s to %s", i, source.Type(), target.Type())
		}
		target.Set(source)
	}
	return nil
}

func expectContact(contactID *int64, exists bool) testStep {
	step := testStep{
		query:  true,
		sql:    "SELECT contact_id FROM notifications.max_users WHERE max_user_id = $1",
		values: []any{contactID},
		checkArgs: func(t *testing.T, args []any) {
			assertTestEqual(t, "MAX user lookup arguments", args, []any{testUserID})
		},
	}
	if !exists {
		step.err = pgx.ErrNoRows
	}
	return step
}

func expectUpsert(contactID *int64) testStep {
	return testStep{
		sql: "SELECT notifications.upsert_max_user(",
		checkArgs: func(t *testing.T, args []any) {
			if len(args) != 6 {
				t.Fatalf("upsert arguments = %d, want 6", len(args))
			}
			assertTestEqual(t, "upsert max_user_id", args[0], testUserID)
			assertTestEqual(t, "upsert contact_id", args[5], contactID)
			var user User
			if err := json.Unmarshal([]byte(args[3].(string)), &user); err != nil {
				t.Fatalf("upsert user JSON: %v", err)
			}
			assertTestEqual(t, "upsert user JSON ID", user.UserID, testUserID)
		},
	}
}

func expectPhoneLookup(phone string, contactID *int64) testStep {
	step := testStep{
		query: true,
		sql:   "SELECT id FROM public.contacts WHERE tel = $1",
		checkArgs: func(t *testing.T, args []any) {
			assertTestEqual(t, "phone lookup arguments", args, []any{phone})
		},
	}
	if contactID == nil {
		step.err = pgx.ErrNoRows
	} else {
		step.values = []any{*contactID}
	}
	return step
}

func expectIncoming(messageRaw []byte, contactID *int64) testStep {
	return testStep{
		sql: "INSERT INTO notifications.max_in_messages_write",
		checkArgs: func(t *testing.T, args []any) {
			assertTestEqual(t, "incoming arguments", args, []any{string(messageRaw), contactID, testAppID})
		},
	}
}

func expectOutgoing(contactID *int64, text string, requestPhone bool) testStep {
	return testStep{
		sql: "INSERT INTO notifications.max_out_messages_write",
		checkArgs: func(t *testing.T, args []any) {
			if len(args) != 4 {
				t.Fatalf("outgoing arguments = %d, want 4", len(args))
			}
			assertTestEqual(t, "outgoing routing", args[1:], []any{testChatID, contactID, testAppID})
			var actual map[string]any
			if err := json.Unmarshal([]byte(args[0].(string)), &actual); err != nil {
				t.Fatalf("outgoing JSON: %v", err)
			}
			expected := map[string]any{"text": text}
			if requestPhone {
				expected["attachments"] = []any{map[string]any{
					"type": "inline_keyboard",
					"payload": map[string]any{
						"buttons": []any{[]any{map[string]any{
							"type": "request_contact",
							"text": sharePhoneButton,
						}}},
					},
				}}
			}
			assertTestEqual(t, "outgoing message", actual, expected)
		},
	}
}

func assertTestEqual(t *testing.T, label string, actual any, expected any) {
	t.Helper()
	if !reflect.DeepEqual(actual, expected) {
		t.Fatalf("%s = %#v, want %#v", label, actual, expected)
	}
}
