# Redis session storage

## Config.php

Add:

```php
define('SESSION_REDIS_DSN', 'redis://eurobeton:PWD@192.168.1.177:5015/0');
define('SESSION_REDIS_NAMESPACE', 'eurobeton');
```

Special characters in the username or password must be URL-encoded. For example, `@` becomes `%40`.

Optional settings:

```php
define('SESSION_REDIS_CONNECT_TIMEOUT', 2.5);
define('SESSION_REDIS_READ_TIMEOUT', 2.5);
define('SESSION_REDIS_LOCK_WAIT_MS', 10000);
define('SESSION_REDIS_LOCK_TTL_MS', 60000);
define('SESSION_REDIS_GC_BATCH_SIZE', 500);
```

## Redis keys

With namespace `eurobeton`, the handler creates:

- `eurobeton:session:<session-id>` — serialized PHP session data, with TTL;
- `eurobeton:lock:<session-id>` — short-lived request lock;
- `eurobeton:expires` — sorted expiry index used to close corresponding PostgreSQL `logins` rows.

## Server requirement

The Redis server alone is not sufficient. PHP must have the `phpredis` extension enabled:

```bash
php -m | grep -i '^redis$'
```

On Debian/Ubuntu it is normally installed with:

```bash
sudo apt install php-redis
```

Restart the applicable PHP-FPM or Apache service after installation.

## Deployment behavior

Existing PostgreSQL-backed sessions are not migrated. Users with active sessions will need to log in again after deployment.

`cmd.php` does not need to change. The replacement preserves the existing `SessManager::start(...)`, `findSession(...)`, and `restart()` API.

PostgreSQL remains necessary for the `logins` table and the rest of the application. The `sessions` table should not be dropped until the deployment has been verified and the body of `sessions_process()` has been checked for side effects not represented in `SessManager.php`.
