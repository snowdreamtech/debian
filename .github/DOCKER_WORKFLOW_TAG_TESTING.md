# Docker Workflow Tag Trigger Testing Guide

## 📋 Overview

This document explains the tag trigger configuration for the Docker multi-platform build workflow and provides testing scenarios to verify the integration with Release-Please.

## 🏷️ Supported Tag Formats

### Primary Format (Release-Please Generated)

The workflow supports Release-Please generated tags:

```yaml
tags:
  - "12-v*" # Matches: 12-v12.15.0, 12-v12.16.0, etc.
  - "13-v*" # Matches: 13-v13.6.0, 13-v13.7.0, etc.
```

### Legacy Formats (Backward Compatibility)

The workflow maintains backward compatibility with legacy tag formats:

```yaml
tags:
  - "[0-9]+.[0-9]+.[0-9]+" # Matches: 1.2.3, 10.20.30
  - "v[0-9]+.[0-9]+.[0-9]+" # Matches: v1.2.3, v10.20.30
  - "V[0-9]+.[0-9]+.[0-9]+" # Matches: V1.2.3, V10.20.30
  - "debian-*.*.*" # Matches: debian-13.6.0, debian-1.0.0
  - "[0-9]+.[0-9]+" # Matches: 1.2, 10.20
  - "v[0-9]+.[0-9]+" # Matches: v1.2, v10.20
  - "V[0-9]+.[0-9]+" # Matches: V1.2, V10.20
  - "debian-*.*" # Matches: debian-13.6, debian-1.0
  - "[0-9]+" # Matches: 1, 2, 10
  - "v[0-9]+" # Matches: v1, v2, v10
  - "V[0-9]+" # Matches: V1, V2, V10
  - "debian-*" # Matches: debian-13, debian-latest
```

## 🧪 Testing Scenarios

### Scenario 1: Release-Please Tag (Primary Use Case)

**Release-Please Configuration:**

```json
{
  "docker/13": "13.7.0"
}
```

**When you merge a Release-Please PR:**

- Release-Please creates tag: `13-v13.7.0`
- Docker workflow triggers: ✅ YES (matches `13-v*`)
- Matrix job runs: Debian 13 only
- Generated Docker tags:
  - `snowdreamtech/debian:13-v13.7.0`
  - `snowdreamtech/debian:13-latest`
  - `snowdreamtech/debian:latest` (since 13 is `is_latest: true`)
  - `snowdreamtech/debian:trixie`
  - `snowdreamtech/debian:trixie-latest`
  - `ghcr.io/snowdreamtech/debian:...` (same tags)

### Scenario 2: Legacy Tag Format

**When you push a legacy tag:**

```bash
git tag 12-v12.15.0
git push origin 12-v12.15.0
```

- Docker workflow triggers: ✅ YES (matches `12-v*`)
- Matrix job runs: Debian 12 only
- Generated Docker tags:
  - `snowdreamtech/debian:12-v12.15.0`
  - `snowdreamtech/debian:12-latest`
  - `snowdreamtech/debian:bookworm`
  - `snowdreamtech/debian:bookworm-latest`
  - `ghcr.io/snowdreamtech/debian:...` (same tags)

### Scenario 3: Manual Workflow Dispatch

You can manually trigger builds for specific versions:

1. Go to **Actions** → **🐳 Docker Multi-Platform Build**
2. Click **Run workflow**
3. Select Debian version: `12`, `13`, or `all`
4. Choose whether to push images (default: `true`)
5. Click **Run workflow**
