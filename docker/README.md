# Docker Images for Debian

This directory contains Docker configurations for multiple Debian versions.

## Supported Versions

| Version | Codename | Base Image | Tag Format |
|---------|----------|------------|------------|
| 12 | Bookworm | debian:12.13-slim | 12-v12.13.0, 12-latest |
| 13 | Trixie | debian:13.4-slim | 13-v13.4.0, 13-latest, latest |

## Directory Structure

```
docker/
├── 12/                          # Debian 12 (Bookworm)
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       ├── 01-base-setup.sh     # Setup script (user, umask)
│       └── 99-base-end.sh       # Final script (workdir, keepalive)
└── 13/                          # Debian 13 (Trixie)
    ├── Dockerfile               # Multi-stage Dockerfile
    ├── docker-entrypoint.sh     # Container entrypoint script
    ├── vimrc.local              # Vim configuration
    └── entrypoint.d/            # Entrypoint scripts directory
        ├── 00-base-init.sh      # Initialization script
        ├── 01-base-setup.sh     # Setup script (user, umask)
        └── 99-base-end.sh       # Final script (workdir, keepalive)
```

## Features

- **Multi-architecture support**: amd64, arm64, arm/v7, arm/v5, i386, ppc64le, s390x, riscv64
- **Minimal base**: Uses slim variants for smaller image size
- **User management**: Support for custom PUID/PGID
- **Configurable**: Environment variables for customization
- **Entrypoint scripts**: Modular initialization system

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBIAN_FRONTEND` | noninteractive | Debian package manager frontend |
| `KEEPALIVE` | 0 | Keep container running (1=yes, 0=no) |
| `CAP_NET_BIND_SERVICE` | 0 | Enable binding to privileged ports |
| `LANG` | C.UTF-8 | Locale setting |
| `UMASK` | 022 | File creation mask |
| `DEBUG` | false | Enable debug output |
| `PGID` | 0 | Group ID for custom user |
| `PUID` | 0 | User ID for custom user |
| `USER` | root | Username |
| `WORKDIR` | /root | Working directory |

## Usage

### Pull from Docker Hub

```bash
# Debian 13 (latest)
docker pull snowdreamtech/debian:latest
docker pull snowdreamtech/debian:13-latest
docker pull snowdreamtech/debian:13-v13.4.0

# Debian 12
docker pull snowdreamtech/debian:12-latest
docker pull snowdreamtech/debian:12-v12.13.0
```

### Pull from GitHub Container Registry

```bash
# Debian 13 (latest)
docker pull ghcr.io/snowdreamtech/debian:latest
docker pull ghcr.io/snowdreamtech/debian:13-latest
docker pull ghcr.io/snowdreamtech/debian:13-v13.4.0

# Debian 12
docker pull ghcr.io/snowdreamtech/debian:12-latest
docker pull ghcr.io/snowdreamtech/debian:12-v12.13.0
```

### Run Container

```bash
# Basic usage
docker run -it snowdreamtech/debian:latest

# With custom user
docker run -it -e PUID=1000 -e PGID=1000 -e USER=myuser snowdreamtech/debian:latest

# Keep container running
docker run -d -e KEEPALIVE=1 snowdreamtech/debian:latest

# With debug output
docker run -it -e DEBUG=true snowdreamtech/debian:latest
```

## Building Locally

```bash
# Build Debian 12
docker build -t debian:12-local docker/12/

# Build Debian 13
docker build -t debian:13-local docker/13/

# Build with specific platform
docker buildx build --platform linux/amd64,linux/arm64 -t debian:13-local docker/13/
```

## Installed Packages

Each image includes the following packages:

- **System utilities**: lsb-release, procps, sudo, vim
- **Compression tools**: zip, unzip, bzip2, xz-utils, gzip
- **File utilities**: file
- **JSON processor**: jq
- **Time zone data**: tzdata
- **Security**: openssl, gnupg, ca-certificates
- **Package management**: aptitude
- **System monitoring**: sysstat
- **Network tools**: wget, curl, git, dnsutils, netcat-traditional, traceroute, iputils-ping, net-tools, lsof
- **Container utilities**: libcap2-bin, gosu
- **Transport**: apt-transport-https

## Entrypoint System

The entrypoint system executes scripts in `/usr/local/bin/entrypoint.d/` in alphabetical order:

1. **00-base-init.sh**: Initialization placeholder
2. **01-base-setup.sh**: User creation, umask configuration
3. **99-base-end.sh**: Working directory setup, command execution, keepalive

## License

MIT License - see [LICENSE](../LICENSE) for details.

## Maintainer

Snowdream Tech - https://github.com/snowdreamtech
