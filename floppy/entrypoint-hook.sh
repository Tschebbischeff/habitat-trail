#!/bin/sh

# Error codes
# None

# Override for environment variables mountable as secrets via _FILE suffix
. /prepare-env.sh

echo "Entrypoint hook done. Starting original entrypoint..."
exec "$@"