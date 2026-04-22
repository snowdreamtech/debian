# Changelog - Debian 13 (Trixie)

All notable changes to the Debian 13 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [13.4.0] - 2026-04-22

### Added
- Initial release of Debian 13 (Trixie) Docker image
- Multi-architecture support (386, amd64, arm/v5, arm/v7, arm64, ppc64le, riscv64, s390x)
- Base image: debian:13.4-slim
- Essential system utilities and tools
- Modular entrypoint system with customizable scripts
- User management with PUID/PGID support
- Vim configuration with Chinese-friendly settings
- Timezone and locale support

### Features
- **System Tools**: lsb-release, procps, sudo, vim
- **Compression**: zip, unzip, bzip2, xz-utils, gzip
- **Network Tools**: wget, curl, git, dnsutils, netcat-traditional, traceroute, iputils-ping, net-tools, lsof
- **Security**: openssl, gnupg, ca-certificates
- **Container Utilities**: gosu, libcap2-bin
- **Package Management**: aptitude, apt-transport-https

### Configuration
- Default locale: C.UTF-8
- Default umask: 022
- Trixie backports enabled
- Command history persistence
