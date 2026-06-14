# Changelog - Debian 12 (Bookworm)

All notable changes to the Debian 12 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [12.14.0](https://github.com/snowdreamtech/debian/compare/12-v12.13.0...12-v12.14.0) (2026-06-14)


### 🚀 Features

* **docker:** add vimrc.local configuration and Debian codename tags ([132c7a7](https://github.com/snowdreamtech/debian/commit/132c7a7d51ab79e7b18965fa0ee9f44ed60834ea))


### 🐛 Bug Fixes

* **docker:** remove backports repositories for stability ([f8c21ed](https://github.com/snowdreamtech/debian/commit/f8c21ed6518e09fa6e21f43820c131eab3db7e96))


### 🛠 Refactoring

* **docker:** remove unnecessary APT sources modification ([1491ef1](https://github.com/snowdreamtech/debian/commit/1491ef12b4a40b5da373260b62870fd41616497b))


### ♻️ Miscellaneous Chores

* **main:** release 0.14.0 ([043d2a4](https://github.com/snowdreamtech/debian/commit/043d2a4202505e42c645e899c6731f5fb8f52c8e))

## [12.13.0] - 2026-04-22

### Added
- Initial release of Debian 12 (Bookworm) Docker image
- Multi-architecture support (386, amd64, arm/v5, arm/v7, arm64, ppc64le, riscv64, s390x)
- Base image: debian:12.13-slim
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
- Bookworm backports enabled
- Command history persistence
