# Debian

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/debian/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/debian/actions/workflows/cd.yml)
[![CodeQL](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/codeql.yml?branch=main&label=CodeQL&logo=github)](https://github.com/snowdreamtech/debian/actions/workflows/codeql.yml)
[![Security Audit](https://img.shields.io/badge/Security-Zizmor%20%7C%20Trivy%20%7C%20Gitleaks-brightgreen)](https://github.com/snowdreamtech/debian/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/debian)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/debian/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/debian)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/debian)

[English](README.md) | [简体中文](README_zh-CN.md)

Debian Linux 的 Docker 基础镜像。支持多平台架构：(amd64, arm32v7, arm64, i386, ppc64le, riscv64, s390x)

## 支持的版本

| 版本 | 代号     | 基础镜像          | Docker 标签                                                    | 状态      |
| :--- | :------- | :---------------- | :------------------------------------------------------------- | :-------- |
| 13   | Trixie   | debian:13.7-slim  | `latest`, `13-latest`, `13-v13.7.0`, `trixie`, `trixie-latest` | ✅ Active |
| 12   | Bookworm | debian:12.15-slim | `12-latest`, `12-v12.15.0`, `bookworm`, `bookworm-latest`      | ✅ Active |

## 使用方法

你可以使用 docker compose 或 docker cli 启动容器。

### Docker Cli

#### 简单模式 (CLI)

```bash
docker run -d \
  --name=debian \
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  snowdreamtech/debian:latest
```

#### 进阶模式 (CLI)

```bash
docker run -d \
  --name=debian \
  -e TZ=Asia/Shanghai \
  -v /path/to/data:/path/to/data \
  --restart unless-stopped \
  snowdreamtech/debian:latest
```

### Docker Compose

#### 简单模式 (Compose)

```yaml
version: "3"

services:
  debian:
    image: snowdreamtech/debian:latest
    container_name: debian
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

#### 进阶模式 (Compose)

```yaml
version: "3"

services:
  debian:
    image: snowdreamtech/debian:latest
    container_name: debian
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /path/to/data:/path/to/data
    restart: unless-stopped
```

## 环境变量

此镜像提供了多个环境变量来自定义其行为。

| 变量                   | 默认值    | 描述                                             |
| :--------------------- | :-------- | :----------------------------------------------- |
| `PUID`                 | `0`       | 运行进程的用户 ID。                              |
| `PGID`                 | `0`       | 运行进程的组 ID。                                |
| `USER`                 | `root`    | 运行进程的用户名。                               |
| `PASSWORDLESS_SUDO`    | `false`   | 设置为 `true` 以授予映射用户免密码 `sudo` 权限。 |
| `WORKDIR`              | `/root`   | 工作目录。                                       |
| `UMASK`                | `022`     | 文件创建的 Umask。                               |
| `DEBUG`                | `false`   | 启用 Entrypoint 的调试日志。                     |
| `KEEPALIVE`            | `0`       | 设置为 `1` 以保持容器持续运行。                  |
| `TZ`                   | `UTC`     | 时区设置。                                       |
| `CAP_NET_BIND_SERVICE` | `0`       | 设置为 `1` 以授予绑定特权端口 (< 1024) 的权限。  |
| `LANG`                 | `C.UTF-8` | 系统的区域与语言设置。                           |

## 特性

### 用户映射与权限

你可以使用 `PUID` 和 `PGID` 将镜像内的用户映射到宿主机的用户 ID 和组 ID。这在挂载数据卷时避免权限问题非常有用。

```bash
docker run -d \
  -e PUID=1000 \
  -e PGID=1000 \
  snowdreamtech/debian:latest
```

默认情况下，映射用户**不具备** `sudo` 权限。若要启用无密码提权（例如在开发或调试阶段）：

```bash
docker run -d \
  -e PUID=1000 \
  -e PGID=1000 \
  -e PASSWORDLESS_SUDO=true \
  snowdreamtech/debian:latest
```

> **安全提示**：请勿在生产环境中开启 `PASSWORDLESS_SUDO=true`。

### Entrypoint 扩展 (`entrypoint.d`)

此镜像支持自定义初始化脚本的扩展机制。任何放置在 `/usr/local/bin/entrypoint.d/` 目录（或构建前项目中的 `entrypoint.d/` 文件夹）中的可执行脚本都将在容器启动时按字母顺序执行。

### 内置软件包

镜像预装了一系列精选的基础工具：

- **Shell**: `bash`, `zsh`
- **Editors**: `vim`, `nano`
- **Network**: `curl`, `wget`, `rsync`, `git`, `dnsutils`, `iputils-ping`, `net-tools`
- **Utils**: `sudo`, `gosu`, `procps`, `jq`, `ca-certificates`, `tzdata`

## 开发指南

### 前置要求

- Docker (>= 20.10) 且已安装 Docker Buildx 插件
- [UniRTM](https://github.com/snowdreamtech/UniRTM) 用于工作区规范与工具链管理

### 质量与验证

```bash
# 安装并验证工具链环境
unirtm run setup

# 运行完整的工作区质量检测（格式化、代码风格、安全性等）
unirtm run verify

# 运行安全审计（Zizmor, Gitleaks, OSV-Scanner, Trivy）
unirtm run audit

# 自动修复支持的代码格式与风格问题
unirtm run fix
```

### 本地构建

```bash
# 构建指定的 Debian 变体
docker build -t debian:13 ./docker/13/
docker build -t debian:12 ./docker/12/
```

## 参考资料

1. [使用 buildx 构建多平台 Docker 镜像](https://icloudnative.io/posts/multiarch-docker-with-buildx/)
2. [如何使用 docker buildx 构建跨平台 Go 镜像](https://waynerv.com/posts/building-multi-architecture-images-with-docker-buildx/#buildx-%E7%9A%84%E8%B7%A8%E5%B9%B3%E5%8F%B0%E6%9E%84%E5%BB%BA%E7%AD%96%E7%95%A5)
3. [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
4. [How to Rapidly Build Multi-Architecture Images with Buildx](https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/)
5. [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
6. [docker/buildx](https://github.com/docker/buildx)

---

Copyright (c) 2024-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
