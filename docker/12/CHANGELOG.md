# Changelog - Debian 12 (Bookworm)

All notable changes to the Debian 12 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.1](https://github.com/snowdreamtech/debian/compare/12-v12.13.0...12-v0.7.1) (2026-04-22)


### 🚀 Features

* **docker:** add debian 12 and 13 docker configurations ([41f58e6](https://github.com/snowdreamtech/debian/commit/41f58e659d4b7aef8da8007575d8e414dc0e6f3d))


### 🛠 Refactoring

* align Dockerfile and entrypoint scripts with alpine project ([db2c316](https://github.com/snowdreamtech/debian/commit/db2c316584f9b37e030433a4ac6c738ed07ad309))


### 📖 Documentation

* **vim:** translate vimrc.local comments from Chinese to English ([7b78041](https://github.com/snowdreamtech/debian/commit/7b78041162cd1477ff3693766cae5d43029b6c49))


### ♻️ Miscellaneous Chores

* **docker:** align docker structure with alpine project ([65064be](https://github.com/snowdreamtech/debian/commit/65064be1fa2d9dcf1ea572c0cebfc21daa3f7f75))
* release 0.6.1 ([f6fc042](https://github.com/snowdreamtech/debian/commit/f6fc042cad7d1c4991a20657655bc4b6b339d0d9))
* release 0.7.1 ([5535492](https://github.com/snowdreamtech/debian/commit/5535492160f3525dff06ff9f0c6d78147467bed3))
* **release:** v0.4.0 - Fix Dependabot docker-compose detection ([e91f7d8](https://github.com/snowdreamtech/debian/commit/e91f7d882f3c7b23260f4da02f0e5e53d6399968))

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
