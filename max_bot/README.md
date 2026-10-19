# MAX webhook app in Go

This service receives MAX webhook updates, links MAX users to existing database
contacts by their shared phone number, stores incoming messages, and queues replies
for the existing outgoing-message worker.

## Account linking

Registration is determined by `notifications.max_users.contact_id`, not by whether
a row exists in `notifications.max_users`.

| Database state | On `bot_started` | On `message_created` |
| --- | --- | --- |
| No MAX user row | Create the profile and request the phone | Create the profile, attempt linking from a shared contact, otherwise request the phone |
| MAX user exists, `contact_id IS NULL` | Request the phone again | Attempt linking from a shared contact, otherwise request the phone again |
| MAX user has a `contact_id` | Preserve the link and confirm that the account is already linked | Preserve the link and store the message without another phone request |

The phone request uses a MAX `request_contact` button labelled
`Поделиться телефоном`. It is not suppressed after the first request. Both update
handlers read the current contact link before refreshing the MAX profile and pass
that link to `notifications.upsert_max_user(...)`.

When an unlinked user shares a contact:

- A matching `public.contacts.tel` links the MAX user and queues the success reply.
- An unmatched phone leaves `contact_id` empty, explains that the phone was not
	found, and includes the phone-sharing button again. A later retry can succeed
	after the contact is added to the database.
- Merely typing a phone number, or sending a contact without a usable phone, does
	not create a link; the bot asks the user to use the phone-sharing button.

The existing phone normalization and lookup rules are unchanged. Russian numbers
are normalized to `7` followed by ten digits; the leading `7` is omitted when
matching `public.contacts.tel`. The service does not create new contact records.

### SMS activation is no longer used

The `bot_started.payload` value is ignored for account linking, including payloads
from old SMS links. This app no longer reads or updates
`notifications.max_user_activation_tokens`, and no longer sends activation-code or
SMS-link instructions. Existing activation tables/data are not deleted or changed.

### What triggers another request

The link is checked on every received `bot_started` and `message_created` update,
including `/start` messages. There is no per-session or per-user suppression flag.
If a contact link is removed from the database, the next handled update requests
the phone again even though the MAX profile still exists.

MAX documents `bot_started` for an initial start or a restart after stopping the
bot. Simply viewing an already active conversation is not a documented start
trigger. Without an incoming update, the server cannot respond to a passive chat
reopen. See the [MAX update documentation](https://dev.max.ru/docs-api/objects/Update).

### Existing phone-ownership limitation

This patch changes when phone sharing is requested; it does not change the existing
contact-attachment parser. That parser does not verify the MAX contact payload
`hash`, so matching an arbitrary contact attachment is not, by itself, verification
that the phone belongs to the sender. MAX documents contact signature verification
in its [keyboard documentation](https://dev.max.ru/docs-api/use-cases/sending-messages/keyboard).

## Database integration

The app expects the existing database objects:

- `notifications.max_users`, `public.contacts`, and
	`notifications.upsert_max_user(...)` for account linking.
- `notifications.max_in_messages_write` for inbound messages.
- `notifications.max_out_messages_write` for outbound replies.

Incoming message storage, profile updates, and queued replies use the same
transaction. On a database error, the handler returns an error and attempts a
rollback rather than treating the user as successfully linked.

This change requires no database migration and no deletion of `max_users` rows.
The database function and write-table definitions are external to this repository.

## Environment variables

See `.env.example`.

- `MAX_APP_ID` supplies `app_id`; `MS_APP_ID` remains a fallback.
- `MAX_REGISTER_WEBHOOK=false` disables automatic webhook registration.
- A non-empty `MAX_WEBHOOK_SECRET` enables webhook secret validation.

The application reads the process environment; it does not load `.env` itself.
Keep the existing environment-loading mechanism used by your deployment.

## HTTP endpoints

- `POST /webhook/max`
- `GET /healthz`

## Run

```bash
export DATABASE_URL='postgres://user:password@127.0.0.1:5432/dbname?sslmode=disable'
export MAX_BOT_TOKEN='your_max_bot_token'
export MAX_APP_ID='123'
export MAX_WEBHOOK_URL='https://your-domain.com/webhook/max'
export MAX_WEBHOOK_SECRET='change_me'

go run ./cmd/max-webhook
```

## Tests and build

Use Go 1.25 or a compatible newer toolchain, as declared in `go.mod`.

```bash
make test
make build
```

The regression tests use transaction doubles, require no live database or MAX
credentials, and add no module dependencies. They cover missing profiles, existing
profiles with a NULL contact link, repeated starts, legacy start payloads, linked
users, phone lookup success/failure, retries after a contact is added, incoming
message routing, outgoing keyboard payloads, and database-error rollback paths.
There are also phone-normalization and contact-parsing tests.

These unit tests do not validate the external database function or write-table
triggers, or actual delivery by the outgoing-message worker. Check those in your
staging environment before deploying.

The binary produced by `make build` is `bin/ebmax`. Deploy it using the existing
service procedure and restart the running service. Keep the production `.env`;
private `.env` files are not included in the updated source archive. This change
does not remove or rewrite messages already queued by the old binary.
