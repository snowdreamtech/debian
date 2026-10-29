#!/bin/sh
# Docker Entrypoint Wrapper
# Purpose: Orchestrates container initialization by executing scripts in entrypoint.d.
# Usage: This script is the default ENTRYPOINT. It iterates over entrypoint.d/ and then
# hands over control to the specific commands via exec (replacing PID 1).
# Dependencies: Requires /usr/local/bin/entrypoint.d directory.
# Design:
#   - POSIX compliant for maximum portability across Alpine/Debian/etc.
#   - Supports DEBUG=true for verbose initialization logging.
#   - Employs 'exec' to ensure graceful shutdown signal forwarding.

set -e

if [ "$DEBUG" = "true" ]; then
  echo "→ [ENTRYPOINT] Executing initialization suite in /usr/local/bin/entrypoint.d"
fi

# 1. Iterate over all scripts in the extension directory.
# This allows decoupled specialized setup (user mapping, env config, etc.)
for script in /usr/local/bin/entrypoint.d/*; do
  if [ -x "$script" ]; then
    if [ "$DEBUG" = "true" ]; then
      echo "→ Running extension: $(basename "$script")"
    fi
    # Execute the extension script with all passed arguments.
    "$script" "$@"
  else
    if [ "$DEBUG" = "true" ] && [ -f "$script" ]; then
      echo "⚠️ Skipping $(basename "$script") (not executable)"
    fi
  fi
done

if [ "$DEBUG" = "true" ]; then
  echo "→ [ENTRYPOINT] Initialization sequence complete."
fi

# 2. Configure working directory
if [ -z "${WORKDIR}" ]; then
  WORKDIR="/root"
fi

if [ "$DEBUG" = "true" ]; then
  echo "→ [ENTRYPOINT] Finalizing environment in ${WORKDIR}"
fi

# We use subshell to test directory access without crashing if set -e is on
if (cd "${WORKDIR}" 2>/dev/null); then
  cd "${WORKDIR}"
else
  if [ "$DEBUG" = "true" ]; then
    echo "⚠️  [ENTRYPOINT] Warning: Cannot transition to ${WORKDIR} (Permission Denied). Staying in $(pwd)"
  fi
fi

# 3. Persistence logic for background-only or idle containers
if [ "${KEEPALIVE}" = "1" ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "♾️ [ENTRYPOINT] Keep-alive enabled. Entering persistence loop..."
  fi
  trap : TERM INT
  tail -f /dev/null &
  wait
fi

# 4. Hand over control to the main command (PID 1 Replacement)
if [ $# -gt 0 ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "🚀 [ENTRYPOINT] Executing command: $*"
  fi

  # If running as root, we drop privileges to the configured PUID/PGID.
  # If already running as a non-root user (e.g., docker run -u 1000), we just exec.
  if [ "$(id -u)" = "0" ]; then
    exec gosu "${PUID:-0}:${PGID:-0}" "$@"
  else
    exec "$@"
  fi
fi
