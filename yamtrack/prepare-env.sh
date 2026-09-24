#!/bin/sh

[ -z "$SECRET" ] && [ -f "$SECRET_FILE" ] && \
  export SECRET="$(cat "$SECRET_FILE")" && \
  unset SECRET_FILE
[ -z "$YAMTRACK_OAUTH_CLIENT_ID" ] && [ -f "$YAMTRACK_OAUTH_CLIENT_ID_FILE" ] && \
  YAMTRACK_OAUTH_CLIENT_ID="$(cat "$YAMTRACK_OAUTH_CLIENT_ID_FILE")" && \
  unset YAMTRACK_OAUTH_CLIENT_ID_FILE
[ -z "$YAMTRACK_OAUTH_CLIENT_SECRET" ] && [ -f "$YAMTRACK_OAUTH_CLIENT_SECRET_FILE" ] && \
  YAMTRACK_OAUTH_CLIENT_SECRET="$(cat "$YAMTRACK_OAUTH_CLIENT_SECRET_FILE")" && \
  unset YAMTRACK_OAUTH_CLIENT_SECRET_FILE
REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_DB="${REDIS_DB:-0}"
REDIS_USER="${REDIS_USER:-default}"
[ -z "$REDIS_USER" ] && [ -f "$REDIS_USER_FILE" ] && \
  REDIS_USER="$(cat "$REDIS_USER_FILE")" && \
  unset REDIS_USER_FILE
REDIS_PASSWORD="${REDIS_PASSWORD:-}"
[ -z "$REDIS_PASSWORD" ] && [ -f "$REDIS_PASSWORD_FILE" ] && \
  REDIS_PASSWORD="$(cat "$REDIS_PASSWORD_FILE")" && \
  unset REDIS_PASSWORD_FILE
export REDIS_URL="redis://$REDIS_USER:$REDIS_PASSWORD@$REDIS_HOST:$REDIS_PORT/$REDIS_DB"
unset REDIS_HOST REDIS_PORT REDIS_DB REDIS_USER REDIS_PASSWORD

SOCIALACCOUNT_PROVIDERS="$(cat <<EOF
{
  "openid_connect": {
    "OAUTH_PKCE_ENABLED": true,
    "APPS": [
      {
        "provider_id": "authelia",
        "name": "Authelia",
        "client_id": "$YAMTRACK_OAUTH_CLIENT_ID",
        "secret": "$YAMTRACK_OAUTH_CLIENT_SECRET",
        "settings": {
          "server_url": "https://authelia.${APP_HOST}/.well-known/openid-configuration"
        }
      }
    ],
    "SCOPE": ["openid", "profile", "email", "groups"]
  }
}
EOF
)"; export SOCIALACCOUNT_PROVIDERS
