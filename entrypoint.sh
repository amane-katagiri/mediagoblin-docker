#!/bin/bash

set -uxe

# If host mounted a manually-created MediaGoblin config file, make a copy that
# the MediaGoblin user can access it.
if [ -e mediagoblin_host.ini ]; then
  >&2 echo "Using host-defined mediagoblin.ini file"
  cp mediagoblin_host.ini mediagoblin.ini
  chown "$MEDIAGOBLIN_USER:$MEDIAGOBLIN_GROUP" mediagoblin.ini
else
  >&2 echo "No host-defined mediagoblin.ini file, using default"
fi

chown \
  --no-dereference \
  --recursive \
  "${MEDIAGOBLIN_USER}:${MEDIAGOBLIN_GROUP}" "$MEDIAGOBLIN_HOME_DIR"
chown \
  --recursive \
  "${MEDIAGOBLIN_USER}:${MEDIAGOBLIN_GROUP}" "${MEDIAGOBLIN_APP_ROOT}/user_dev"
if [ ! -L "${MEDIAGOBLIN_APP_ROOT}/mediagoblin/static" ]; then
  rm -rf "${MEDIAGOBLIN_APP_ROOT}/user_dev/static"
  mv "${MEDIAGOBLIN_APP_ROOT}/mediagoblin/static" "${MEDIAGOBLIN_APP_ROOT}/user_dev/"
  ln -s "../user_dev/static" "${MEDIAGOBLIN_APP_ROOT}/mediagoblin/static"
fi

su "$MEDIAGOBLIN_USER" -c './init-mediagoblin.sh'
if [ $# -eq 1 ]; then
  su "$MEDIAGOBLIN_USER" -c "$1"
else
  su "$MEDIAGOBLIN_USER" -c './lazyserver.sh --server-name=broadcast'
fi
