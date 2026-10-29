#!/bin/sh
# Base Initialization & Extension Bootstrap Hook
# Purpose: Provides a standardized early-stage hook for fundamental initialization.
# Design:
#   - Executed as the very first script in the entrypoint.d sequence (00-*).
#   - Acts as an extension point for third-party or downstream image boots.
# Usage:
#   - downstream images should mount or copy their early setup here.
#   - placeholder for core system-level boots (e.g., entropy seeding).

set -e

if [ "$DEBUG" = "true" ]; then
  echo "→ [EXTENSION] Bootstrapping global initialization suite (00-base-init.sh)"
fi

# 1. Timezone Configuration (Root-only operation)
if [ -n "${TZ}" ]; then
  if [ "$(id -u)" = "0" ]; then
    if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
      if [ "$DEBUG" = "true" ]; then
        echo "→ [EXTENSION] Setting system timezone: ${TZ}"
      fi
      ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
      echo "${TZ}" >/etc/timezone
    fi
  else
    if [ "$DEBUG" = "true" ]; then
      echo "⚠️  [EXTENSION] Non-root user: Skipping system-level timezone configuration."
    fi
  fi
fi

# 2. Network Capabilities (Allow unprivileged port binding, root-only operation)
if [ "${CAP_NET_BIND_SERVICE}" = "1" ]; then
  if [ "$(id -u)" = "0" ]; then
    if [ "$DEBUG" = "true" ]; then
      echo "→ [EXTENSION] Attempting to enable unprivileged port binding (<1024)"
    fi
    # Requires CAP_SYS_CTL or privileged mode. Fail gracefully if not possible.
    sysctl -w net.ipv4.ip_unprivileged_port_start=0 || {
      if [ "$DEBUG" = "true" ]; then
        echo "⚠️  [EXTENSION] Failed to set net.ipv4.ip_unprivileged_port_start. Ensure container has CAP_SYS_ADMIN."
      fi
    }
  else
    if [ "$DEBUG" = "true" ]; then
      echo "⚠️  [EXTENSION] Non-root user: Skipping network capability configuration."
    fi
  fi
fi
