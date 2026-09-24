#!/bin/sh

# Error codes
# None

# Override for environment variables mountable as secrets via _FILE suffix
. /prepare-env.sh

CRONTAB_USER="root"
tmpCronFile="$(mktemp)"
crontab -u "$CRONTAB_USER" -l 2>/dev/null | grep -v '/backup\.sh$' >"$tmpCronFile"
echo "${YAMTRACK_BACKUP_SCHEDULE} /backup.sh" >>"$tmpCronFile"
crontab -u "$CRONTAB_USER" "$tmpCronFile" || exit 1
rm "$tmpCronFile"

crond -b -l 2

echo "Entrypoint hook done. Starting original entrypoint..."
exec "$@"