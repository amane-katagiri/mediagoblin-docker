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

if [ $# -eq 1 ]; then
  su "$MEDIAGOBLIN_USER" -c "$1"
else
  su "$MEDIAGOBLIN_USER" -c './lazycelery.sh --loglevel=INFO'
fi
