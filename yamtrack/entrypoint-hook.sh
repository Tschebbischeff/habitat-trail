#!/bin/sh

# Error codes
# None

# Override for environment variables mountable as secrets via _FILE suffix
[ -z "$SECRET" ] && [ -f "$SECRET_FILE" ] && \
  export SECRET="$(cat "$SECRET_FILE")" && \
  unset SECRET_FILE
[ -z "$YAMTRACK_OAUTH_CLIENT_ID" ] && [ -f "$YAMTRACK_OAUTH_CLIENT_ID_FILE" ] && \
  YAMTRACK_OAUTH_CLIENT_ID="$(cat "$YAMTRACK_OAUTH_CLIENT_ID_FILE")" && \
  unset YAMTRACK_OAUTH_CLIENT_ID_FILE
[ -z "$YAMTRACK_OAUTH_CLIENT_SECRET" ] && [ -f "$YAMTRACK_OAUTH_CLIENT_SECRET_FILE" ] && \
  YAMTRACK_OAUTH_CLIENT_SECRET="$(cat "$YAMTRACK_OAUTH_CLIENT_SECRET_FILE")" && \
  unset YAMTRACK_OAUTH_CLIENT_SECRET_FILE

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
    ]
  }
}
EOF
)"; export SOCIALACCOUNT_PROVIDERS

CRONTAB_USER="root"
tmpCronFile="$(mktemp)"
crontab -u "$CRONTAB_USER" -l 2>/dev/null | grep -v '/backup\.sh$' >"$tmpCronFile"
echo "${YAMTRACK_BACKUP_SCHEDULE} /backup.sh" >>"$tmpCronFile"
crontab -u "$CRONTAB_USER" "$tmpCronFile" || exit 1
rm "$tmpCronFile"

crond -b -l 2

echo "Entrypoint hook done. Starting original entrypoint..."
exec "$@"