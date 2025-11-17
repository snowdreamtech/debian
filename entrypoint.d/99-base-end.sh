#!/bin/sh
set -e

# set workdir
if [ -z "${WORKDIR}" ]; then
  WORKDIR="/root"
fi
cd "${WORKDIR}"

# exec commands
if [ $# -gt 0 ]; then
  gosu "${PUID}:${PGID}" "$@"
fi

# keep the docker container running
# https://github.com/docker/compose/issues/1926#issuecomment-422351028
if [ "${KEEPALIVE}" -eq 1 ]; then
  trap : TERM INT
  tail -f /dev/null &
  wait
  # sleep infinity & wait
fi