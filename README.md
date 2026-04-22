# Docker Images for Debian

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/debian/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/debian/actions/workflows/cd.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/snowdreamtech/debian?logo=docker)](https://hub.docker.com/r/snowdreamtech/debian)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-snowdreamtech%2Fdebian-blue?logo=github)](https://github.com/snowdreamtech/debian/pkgs/container/debian)
[![Multi-Architecture](https://img.shields.io/badge/Architectures-8-blue)](https://github.com/snowdreamtech/debian)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
[![Release](https://img.shields.io/github/v/release/snowdreamtech/debian?logo=github&sort=semver)](https://github.com/snowdreamtech/debian/releases/latest)

[English](README.md) | [简体中文](README_zh-CN.md)

Enterprise-grade Docker base images for Debian with comprehensive multi-architecture support and production-ready configurations.

## 🌟 Features

- **Multi-Architecture Support**: Native support for 8 architectures (amd64, arm64, arm/v7, arm/v5, i386, ppc64le, s390x, riscv64)
- **Multiple Debian Versions**: Debian 12 (Bookworm) and Debian 13 (Trixie)
- **Minimal Base**: Built on official slim variants for smaller image sizes
- **Production Ready**: Pre-configured with essential tools and security hardening
- **Flexible User Management**: Support for custom PUID/PGID
- **Modular Entrypoint System**: Extensible initialization scripts
- **Automated Builds**: CI/CD pipeline with automated testing and publishing

## 📦 Supported Versions

| Version | Codename | Base Image | Docker Tags | Status |
|---------|----------|------------|-------------|--------|
| 13 | Trixie | debian:13.4-slim | `latest`, `13-latest`, `13-v13.4.0` | ✅ Active |
| 12 | Bookworm | debian:12.13-slim | `12-latest`, `12-v12.13.0` | ✅ Active |

## 🚀 Quick Start

### Pull from Docker Hub

```bash
# Latest (Debian 13)
docker pull snowdreamtech/debian:latest

# Debian 13 (Trixie)
docker pull snowdreamtech/debian:13-latest
docker pull snowdreamtech/debian:13-v13.4.0

# Debian 12 (Bookworm)
docker pull snowdreamtech/debian:12-latest
docker pull snowdreamtech/debian:12-v12.13.0
```

### Pull from GitHub Container Registry

```bash
# Latest (Debian 13)
docker pull ghcr.io/snowdreamtech/debian:latest

# Debian 13 (Trixie)
docker pull ghcr.io/snowdreamtech/debian:13-latest
docker pull ghcr.io/snowdreamtech/debian:13-v13.4.0

# Debian 12 (Bookworm)
docker pull ghcr.io/snowdreamtech/debian:12-latest
docker pull ghcr.io/snowdreamtech/debian:12-v12.13.0
```

### Basic Usage

```bash
# Run interactive shell
docker run -it snowdreamtech/debian:latest

# Run with custom user
docker run -it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  snowdreamtech/debian:latest

# Keep container running in background
docker run -d \
  -e KEEPALIVE=1 \
  --name my-debian \
  snowdreamtech/debian:latest

# Run with debug output
docker run -it \
  -e DEBUG=true \
  snowdreamtech/debian:latest
```

## 🏗️ Architecture

### Supported Platforms

| Architecture | Status | Notes |
|--------------|--------|-------|
| linux/amd64 | ✅ Supported | x86-64 |
| linux/arm64 | ✅ Supported | ARM 64-bit |
| linux/arm/v7 | ✅ Supported | ARM 32-bit v7 |
| linux/arm/v5 | ✅ Supported | ARM 32-bit v5 |
| linux/386 | ✅ Supported | x86 32-bit |
| linux/ppc64le | ✅ Supported | PowerPC 64-bit LE |
| linux/s390x | ✅ Supported | IBM System z |
| linux/riscv64 | ✅ Supported | RISC-V 64-bit |

### Directory Structure

```text
debian/
├── docker/                      # Docker configurations
│   ├── 12/                      # Debian 12 (Bookworm)
│   │   ├── Dockerfile           # Multi-stage Dockerfile
│   │   ├── docker-entrypoint.sh # Container entrypoint
│   │   ├── vimrc.local          # Vim configuration
│   │   └── entrypoint.d/        # Modular entrypoint scripts
│   ├── 13/                      # Debian 13 (Trixie)
│   │   ├── Dockerfile           # Multi-stage Dockerfile
│   │   ├── docker-entrypoint.sh # Container entrypoint
│   │   ├── vimrc.local          # Vim configuration
│   │   └── entrypoint.d/        # Modular entrypoint scripts
│   └── README.md                # Docker documentation
├── .github/workflows/           # CI/CD pipelines
│   ├── ci.yml                   # Continuous Integration
│   └── cd.yml                   # Continuous Deployment
└── docs/                        # Project documentation
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | noninteractive | Debian package manager frontend |
| `KEEPALIVE` | 0 | Keep container running (1=yes, 0=no) |
| `CAP_NET_BIND_SERVICE` | 0 | Enable binding to privileged ports (<1024) |
| `LANG` | C.UTF-8 | Locale setting for UTF-8 support |
| `UMASK` | 022 | File creation mask |
| `DEBUG` | false | Enable debug output in entrypoint scripts |
| `PGID` | 0 | Group ID for custom user |
| `PUID` | 0 | User ID for custom user |
| `USER` | root | Username (creates user if not root) |
| `WORKDIR` | /root | Working directory |

### Installed Packages

Each image includes essential tools for development and operations:

### System Utilities

- lsb-release, procps, sudo, vim

### Compression Tools

- zip, unzip, bzip2, xz-utils, gzip

### File & Data Tools

- file, jq

### Time & Locale

- tzdata

### Security & Certificates

- openssl, gnupg, ca-certificates

### Package Management

- aptitude

### System Monitoring

- sysstat

### Network Tools

- wget, curl, git, dnsutils, netcat-traditional, traceroute, iputils-ping, net-tools, lsof

### Container Utilities

- libcap2-bin, gosu

### Transport

- apt-transport-https

## 🔧 Building Locally

### Prerequisites

- Docker 20.10+ or Docker Desktop
- Docker Buildx (for multi-architecture builds)

### Build Commands

```bash
# Build Debian 12
docker build -t debian:12-local docker/12/

# Build Debian 13
docker build -t debian:13-local docker/13/

# Build with specific platform
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t debian:13-local \
  docker/13/

# Build all platforms (requires buildx)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v5,linux/386,linux/ppc64le,linux/s390x,linux/riscv64 \
  -t debian:13-multi \
  docker/13/
```

## 📚 Documentation

- [Docker Configuration Guide](docker/README.md) - Detailed docker setup and usage
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to this project
- [Changelog](CHANGELOG.md) - Version history and release notes
- [Security Policy](SECURITY.md) - Security reporting and policies

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on:

- Code of Conduct
- Development workflow
- Commit message conventions
- Pull request process

## 🔒 Security

Security is a top priority. If you discover a security vulnerability, please follow our [Security Policy](SECURITY.md) for responsible disclosure.

## 📄 License

This project is licensed under the **MIT License**.
Copyright (c) 2026-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
See the [LICENSE](./LICENSE) file for the full license text.

## 🙏 Acknowledgments

- Based on official [Debian Docker images](https://hub.docker.com/_/debian)
- Inspired by best practices from the Docker community
- Built with [GitHub Actions](https://github.com/features/actions)

## 📞 Support

- 📧 Email: <sn0wdr1am@qq.com>
- 🐛 Issues: [GitHub Issues](https://github.com/snowdreamtech/debian/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/snowdreamtech/debian/discussions)

## Star History

[![Star History Chart](https://api.star-history.com/image?repos=snowdreamtech/debian&type=date&legend=top-left)](https://www.star-history.com/?repos=snowdreamtech%2Fdebian&type=date&legend=top-left)
