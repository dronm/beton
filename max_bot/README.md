# MAX webhook app in Go

This service mirrors the PHP logic you provided, but receives updates through a MAX webhook instead of Long Polling.

## What it does

- handles `bot_started`
- handles `message_created`
- binds a MAX user by activation token from `notifications.max_user_activation_tokens`
- stores inbound messages in `notifications.max_in_messages_write`
- enqueues outbound messages in `notifications.max_out_messages_write`
- asks an unbound user to share their phone with a `request_contact` button
- binds `notifications.max_users.contact_id` by matching the shared phone against `public.contacts.tel`
- optionally registers the webhook on startup

## Environment variables

See `.env.example`.

Notes:

- `MAX_APP_ID` is the primary variable for `app_id`
- `MS_APP_ID` is also accepted as a fallback, to match your current naming
- set `MAX_REGISTER_WEBHOOK=false` if you want to configure the webhook outside the app

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

## Notes

- the app expects your DB function `notifications.upsert_max_user(...)` to exist
- the app writes to the same write tables as your PHP script
- webhook secret validation is enabled only when `MAX_WEBHOOK_SECRET` is non-empty
