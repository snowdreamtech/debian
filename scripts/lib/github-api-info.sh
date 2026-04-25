#!/usr/bin/env sh
# Copyright (c) 2026 SnowdreamTech. All rights reserved.
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

# scripts/lib/github-api-info.sh
# Purpose: Fetch and display GitHub API rate limit information

# ── GitHub API Rate Limit Functions ──────────────────────────────────────────

# Purpose: Fetch GitHub API rate limit for a given token
# Params:
#   $1 - Token name (for display)
#   $2 - Token value
# Returns: JSON with rate limit info or empty if failed
get_github_rate_limit() {
  _token_name="${1:-}"
  _token_value="${2:-}"

  if [ -z "${_token_value}" ]; then
    return 1
  fi

  # Fetch rate limit from GitHub API
  _response=$(curl -s -H "Authorization: Bearer ${_token_value}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/rate_limit 2>/dev/null)

  if [ -z "${_response}" ]; then
    return 1
  fi

  echo "${_response}"
}

# Purpose: Parse rate limit JSON and extract core API info
# Params:
#   $1 - JSON response from rate_limit API
# Outputs: Formatted rate limit info
parse_rate_limit() {
  _json="${1:-}"

  if [ -z "${_json}" ]; then
    echo "N/A|N/A|N/A|N/A"
    return
  fi

  # Extract the "core" section first
  # Use sed to remove the last line (more portable than head -n -1)
  _core_section=$(echo "${_json}" | sed -n '/"core":/,/"search":/p' | sed '$d')

  if [ -z "${_core_section}" ]; then
    # Fallback: try to extract core section differently
    _core_section=$(echo "${_json}" | grep -A 5 '"core":')
  fi

  # Extract values from core section
  _limit=$(echo "${_core_section}" | grep -o '"limit": *[0-9]*' | grep -o '[0-9]*')
  _remaining=$(echo "${_core_section}" | grep -o '"remaining": *[0-9]*' | grep -o '[0-9]*')
  _reset=$(echo "${_core_section}" | grep -o '"reset": *[0-9]*' | grep -o '[0-9]*')
  _used=$(echo "${_core_section}" | grep -o '"used": *[0-9]*' | grep -o '[0-9]*')

  # Convert reset timestamp to human-readable format
  if [ -n "${_reset}" ] && [ "${_reset}" != "0" ]; then
    # Try to use date command (may vary by platform)
    _reset_time=$(date -r "${_reset}" "+%Y-%m-%d %H:%M:%S UTC" 2>/dev/null || date -d "@${_reset}" "+%Y-%m-%d %H:%M:%S UTC" 2>/dev/null || echo "Unknown")
  else
    _reset_time="N/A"
  fi

  # Calculate percentage used
  if [ -n "${_limit}" ] && [ -n "${_used}" ] && [ "${_limit}" != "0" ]; then
    _percentage=$(((_used * 100) / _limit))
  else
    _percentage="N/A"
  fi

  echo "${_limit:-N/A}|${_remaining:-N/A}|${_used:-N/A}|${_percentage}%|${_reset_time}"
}

# Purpose: Generate GitHub API rate limit summary table
# Outputs: Markdown table to CI_STEP_SUMMARY
generate_github_api_summary() {
  if [ -z "${CI_STEP_SUMMARY:-}" ]; then
    return 0
  fi

  {
    echo ""
    echo "### 🔑 GitHub API Rate Limit Status"
    echo ""
    echo "| Token | Limit | Remaining | Used | Usage % | Reset Time (UTC) |"
    echo "| :--- | ---: | ---: | ---: | ---: | :--- |"
  } >>"${CI_STEP_SUMMARY}"

  # Check GITHUB_TOKEN
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    _gh_response=$(get_github_rate_limit "GITHUB_TOKEN" "${GITHUB_TOKEN}")
    _gh_info=$(parse_rate_limit "${_gh_response}")

    _limit=$(echo "${_gh_info}" | cut -d'|' -f1)
    _remaining=$(echo "${_gh_info}" | cut -d'|' -f2)
    _used=$(echo "${_gh_info}" | cut -d'|' -f3)
    _percentage=$(echo "${_gh_info}" | cut -d'|' -f4)
    _reset_time=$(echo "${_gh_info}" | cut -d'|' -f5)

    # Add warning emoji if usage is high
    if [ "${_remaining}" != "N/A" ] && [ "${_remaining}" -lt 100 ]; then
      _token_display="⚠️ GITHUB_TOKEN"
    else
      _token_display="GITHUB_TOKEN"
    fi

    echo "| ${_token_display} | ${_limit} | ${_remaining} | ${_used} | ${_percentage} | ${_reset_time} |" >>"${CI_STEP_SUMMARY}"
  fi

  # Check WORKFLOW_SECRET
  if [ -n "${WORKFLOW_SECRET:-}" ]; then
    _ws_response=$(get_github_rate_limit "WORKFLOW_SECRET" "${WORKFLOW_SECRET}")
    _ws_info=$(parse_rate_limit "${_ws_response}")

    _limit=$(echo "${_ws_info}" | cut -d'|' -f1)
    _remaining=$(echo "${_ws_info}" | cut -d'|' -f2)
    _used=$(echo "${_ws_info}" | cut -d'|' -f3)
    _percentage=$(echo "${_ws_info}" | cut -d'|' -f4)
    _reset_time=$(echo "${_ws_info}" | cut -d'|' -f5)

    # Add warning emoji if usage is high
    if [ "${_remaining}" != "N/A" ] && [ "${_remaining}" -lt 100 ]; then
      _token_display="⚠️ WORKFLOW_SECRET"
    else
      _token_display="WORKFLOW_SECRET"
    fi

    echo "| ${_token_display} | ${_limit} | ${_remaining} | ${_used} | ${_percentage} | ${_reset_time} |" >>"${CI_STEP_SUMMARY}"
  fi

  {
    echo ""
    echo "> 📊 Rate limits are per token and reset hourly. [Learn more](https://docs.github.com/en/rest/rate-limit)"
    echo ""
  } >>"${CI_STEP_SUMMARY}"
}

# Purpose: Add GitHub API info to existing summary
# This can be called at the end of any script that writes to CI_STEP_SUMMARY
append_github_api_info() {
  if [ -n "${CI_STEP_SUMMARY:-}" ] && [ -n "${GITHUB_TOKEN:-}${WORKFLOW_SECRET:-}" ]; then
    generate_github_api_summary
  fi
}
