#!/usr/bin/env sh
# Copyright (c) 2026 SnowdreamTech. All rights reserved.
# Licensed under the MIT License. See LICENSE file in the project root for full license information.

#
# smoke-test-gen-dependabot.sh
# Purpose: Verifies that gen-dependabot.sh correctly detects ecosystems and generates valid YAML.

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")/.." && pwd)
GEN_SCRIPT="$SCRIPT_DIR/scripts/gen-dependabot.sh"
TEMP_DIR=$(mktemp -d)

echo "🧪 Starting Dependabot Generator Smoke Test..."
echo "📂 Temp directory: $TEMP_DIR"

cleanup() {
  rm -rf "$TEMP_DIR"
  echo "🧹 Cleanup complete."
}
trap cleanup EXIT

# 1. Setup Mock Workspace
mkdir -p "$TEMP_DIR/root"
mkdir -p "$TEMP_DIR/root/docs"
mkdir -p "$TEMP_DIR/root/.devcontainer"
mkdir -p "$TEMP_DIR/root/.github/workflows"

cd "$TEMP_DIR/root"
git init -q
git config user.email "test@example.com"
git config user.name "Test User"

# Create dummy files
touch "package.json"
touch "docs/package.json"
touch ".devcontainer/Dockerfile"
touch ".pre-commit-config.yaml"
touch ".github/workflows/ci.yml"

# MUST track files for git ls-files to work
git add .
git commit -m "initial" -q

# Run the script and capture output (using --dry-run to get STDOUT)
echo "🏃 Running generator..."
OUTPUT_FILE="$TEMP_DIR/dependabot.yml"
sh "$GEN_SCRIPT" --dry-run >"$OUTPUT_FILE"

# Debug: Show generated file if test fails
on_failure() {
  echo "DEBUG: Current Directory: $(pwd)"
  echo "DEBUG: Git status:"
  git status
  echo "DEBUG: git ls-files outcome:"
  git ls-files
  echo "DEBUG: Generated dependabot.yml contents:"
  cat "$OUTPUT_FILE"
}

# 3. Assertions
assert_contains() {
  _pattern="$1"
  if grep -q "$_pattern" "$OUTPUT_FILE"; then
    echo "✅ Found: $_pattern"
  else
    echo "❌ Missing: $_pattern"
    on_failure
    exit 1
  fi
}

echo "🔍 Verifying generated content..."
assert_contains 'package-ecosystem: "npm"'
assert_contains 'directory: "/"'
assert_contains 'directory: "/docs"'
assert_contains 'package-ecosystem: "docker"'
assert_contains 'package-ecosystem: "pre-commit"'
assert_contains "📦-npm-root-patch-minor"
assert_contains "🧹-root-lint-dependencies"
assert_contains "🔧-actions-updates"
assert_contains 'rebase-strategy: "auto"'
assert_contains 'open-pull-requests-limit: 5'
assert_contains 'update-types:'
assert_contains 'exclude-patterns:'
assert_contains 'cooldown:'
assert_contains 'default-days: 7'

echo "✨ Smoke test PASSED successfully!"
