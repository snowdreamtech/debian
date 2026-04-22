#!/bin/sh
# Environment & User Setup Extension
# Purpose: Configures the runtime environment, including PUID/PGID mapping and UMASK.
# Design: Ensures the container environment aligns with host-provided UID/GID for volumes.
# Usage: Automatically executed by the core docker-entrypoint.sh.

set -e

# Create a user with PUID and PGID if specified and doesn't exist
if [ "$(id -u)" = "0" ]; then
  if [ "${USER}" != "root" ] && [ "${PUID:-0}" -ne 0 ] && [ "${PGID:-0}" -ne 0 ]; then
    if [ "$DEBUG" = "true" ]; then
      echo "→ [EXTENSION] Ensuring user mapping: ${USER} (UID: ${PUID}, GID: ${PGID})"
    fi

    # 1. Handle group creation/mapping
    local _EFFECTIVE_GROUP="${USER}"
    if ! getent group "${PGID}" >/dev/null 2>&1; then
      if [ "$DEBUG" = "true" ]; then
        echo "→ [EXTENSION] Creating group: ${USER} (GID: ${PGID})"
      fi
      addgroup --gid "${PGID}" "${USER}"
    else
      _EFFECTIVE_GROUP=$(getent group "${PGID}" | cut -d: -f1)
      if [ "$DEBUG" = "true" ]; then
        echo "→ [EXTENSION] GID ${PGID} already exists as group: ${_EFFECTIVE_GROUP}. Using it."
      fi
    fi

    # 2. Handle user creation/mapping
    if ! getent passwd "${PUID}" >/dev/null 2>&1; then
      if [ "$DEBUG" = "true" ]; then
        echo "→ [EXTENSION] Creating user: ${USER} (UID: ${PUID}, Group: ${_EFFECTIVE_GROUP})"
      fi
      adduser --home /home/"${USER}" --uid "${PUID}" --gid "${PGID}" --gecos "${USER}" --shell /bin/bash --disabled-password "${USER}"
    else
      local _EXISTING_USER
      _EXISTING_USER=$(getent passwd "${PUID}" | cut -d: -f1)
      if [ "$DEBUG" = "true" ]; then
        echo "→ [EXTENSION] UID ${PUID} already exists as user: ${_EXISTING_USER}. Using it."
      fi
      # Update the USER variable to reflect the system reality if they differ
      if [ "${USER}" != "$_EXISTING_USER" ]; then
        USER="${_EXISTING_USER}"
      fi
    fi

    # 3. Ensure home directory permissions
    if [ -d "/home/${USER}" ]; then
      chown -R "${PUID}:${PGID}" "/home/${USER}"
    fi

    # 4. Privilege Escalation (Sudoers)
    if [ "${PASSWORDLESS_SUDO:-false}" = "true" ]; then
      if [ -f "/etc/sudoers" ]; then
        if [ "$DEBUG" = "true" ]; then
          echo "→ [EXTENSION] Granting passwordless sudo to: ${USER} (PASSWORDLESS_SUDO=true)"
        fi
        echo "${USER} ALL=(ALL) NOPASSWD:ALL" >"/etc/sudoers.d/${USER}"
        chmod 0440 "/etc/sudoers.d/${USER}"
      fi
    elif [ "$DEBUG" = "true" ]; then
      echo "→ [EXTENSION] Passwordless sudo not granted to: ${USER}. Set PASSWORDLESS_SUDO=true to enable."
    fi
  fi
else
  if [ "$DEBUG" = "true" ]; then
    echo "→ [EXTENSION] Running as non-root (UID: $(id -u)). Skipping dynamic user mapping."
  fi
fi

# Apply system umask for file creation consistency
if [ -z "${UMASK}" ]; then
  UMASK=022
fi

if [ "$DEBUG" = "true" ]; then
  echo "→ [EXTENSION] Applying system umask: ${UMASK}"
fi
umask "${UMASK}"
