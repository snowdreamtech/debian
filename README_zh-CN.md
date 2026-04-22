# Debian Docker 镜像

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/debian/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/debian/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/debian/actions/workflows/cd.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/snowdreamtech/debian?logo=docker)](https://hub.docker.com/r/snowdreamtech/debian)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-snowdreamtech%2Fdebian-blue?logo=github)](https://github.com/snowdreamtech/debian/pkgs/container/debian)
[![Multi-Architecture](https://img.shields.io/badge/Architectures-8-blue)](https://github.com/snowdreamtech/debian)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
[![Release](https://img.shields.io/github/v/release/snowdreamtech/debian?logo=github&sort=semver)](https://github.com/snowdreamtech/debian/releases/latest)

[English](README.md) | [简体中文](README_zh-CN.md)

企业级 Debian Docker 基础镜像，支持全面的多架构和生产就绪配置。

## 🌟 特性

- **多架构支持**：原生支持 8 种架构（amd64、arm64、arm/v7、arm/v5、i386、ppc64le、s390x、riscv64）
- **多个 Debian 版本**：Debian 12（Bookworm）和 Debian 13（Trixie）
- **最小化基础镜像**：基于官方 slim 变体构建，镜像体积更小
- **生产就绪**：预配置了必要工具和安全加固
- **灵活的用户管理**：支持自定义 PUID/PGID
- **模块化入口点系统**：可扩展的初始化脚本
- **自动化构建**：CI/CD 流水线，自动测试和发布

## 📦 支持的版本

| 版本 | 代号 | 基础镜像 | Docker 标签 | 状态 |
|------|------|----------|-------------|------|
| 13 | Trixie | debian:13.4-slim | `latest`, `13-latest`, `13-v13.4.0` | ✅ 活跃 |
| 12 | Bookworm | debian:12.13-slim | `12-latest`, `12-v12.13.0` | ✅ 活跃 |

## 🚀 快速开始

### 从 Docker Hub 拉取

```bash
# 最新版本（Debian 13）
docker pull snowdreamtech/debian:latest

# Debian 13（Trixie）
docker pull snowdreamtech/debian:13-latest
docker pull snowdreamtech/debian:13-v13.4.0

# Debian 12（Bookworm）
docker pull snowdreamtech/debian:12-latest
docker pull snowdreamtech/debian:12-v12.13.0
```

### 从 GitHub Container Registry 拉取

```bash
# 最新版本（Debian 13）
docker pull ghcr.io/snowdreamtech/debian:latest

# Debian 13（Trixie）
docker pull ghcr.io/snowdreamtech/debian:13-latest
docker pull ghcr.io/snowdreamtech/debian:13-v13.4.0

# Debian 12（Bookworm）
docker pull ghcr.io/snowdreamtech/debian:12-latest
docker pull ghcr.io/snowdreamtech/debian:12-v12.13.0
```

### 基本用法

```bash
# 运行交互式 shell
docker run -it snowdreamtech/debian:latest

# 使用自定义用户运行
docker run -it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  snowdreamtech/debian:latest

# 在后台保持容器运行
docker run -d \
  -e KEEPALIVE=1 \
  --name my-debian \
  snowdreamtech/debian:latest

# 启用调试输出运行
docker run -it \
  -e DEBUG=true \
  snowdreamtech/debian:latest
```

## 🏗️ 架构

### 支持的平台

| 架构 | 状态 | 说明 |
|------|------|------|
| linux/amd64 | ✅ 支持 | x86-64 |
| linux/arm64 | ✅ 支持 | ARM 64 位 |
| linux/arm/v7 | ✅ 支持 | ARM 32 位 v7 |
| linux/arm/v5 | ✅ 支持 | ARM 32 位 v5 |
| linux/386 | ✅ 支持 | x86 32 位 |
| linux/ppc64le | ✅ 支持 | PowerPC 64 位 LE |
| linux/s390x | ✅ 支持 | IBM System z |
| linux/riscv64 | ✅ 支持 | RISC-V 64 位 |

### 目录结构

```text
debian/
├── docker/                      # Docker 配置
│   ├── 12/                      # Debian 12（Bookworm）
│   │   ├── Dockerfile           # 多阶段 Dockerfile
│   │   ├── docker-entrypoint.sh # 容器入口点
│   │   ├── vimrc.local          # Vim 配置
│   │   └── entrypoint.d/        # 模块化入口点脚本
│   ├── 13/                      # Debian 13（Trixie）
│   │   ├── Dockerfile           # 多阶段 Dockerfile
│   │   ├── docker-entrypoint.sh # 容器入口点
│   │   ├── vimrc.local          # Vim 配置
│   │   └── entrypoint.d/        # 模块化入口点脚本
│   └── README.md                # Docker 文档
├── .github/workflows/           # CI/CD 流水线
│   ├── ci.yml                   # 持续集成
│   └── cd.yml                   # 持续部署
└── docs/                        # 项目文档
```

## ⚙️ 配置

### 环境变量

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `DEBIAN_FRONTEND` | noninteractive | Debian 包管理器前端 |
| `KEEPALIVE` | 0 | 保持容器运行（1=是，0=否）|
| `CAP_NET_BIND_SERVICE` | 0 | 启用绑定到特权端口（<1024）|
| `LANG` | C.UTF-8 | UTF-8 支持的区域设置 |
| `UMASK` | 022 | 文件创建掩码 |
| `DEBUG` | false | 在入口点脚本中启用调试输出 |
| `PGID` | 0 | 自定义用户的组 ID |
| `PUID` | 0 | 自定义用户的用户 ID |
| `USER` | root | 用户名（如果不是 root 则创建用户）|
| `WORKDIR` | /root | 工作目录 |

### 已安装的软件包

每个镜像都包含开发和运维的必要工具：

**系统工具**

- lsb-release、procps、sudo、vim

**压缩工具**

- zip、unzip、bzip2、xz-utils、gzip

**文件和数据工具**

- file、jq

**时间和区域设置**

- tzdata

**安全和证书**

- openssl、gnupg、ca-certificates

**包管理**

- aptitude

**系统监控**

- sysstat

**网络工具**

- wget、curl、git、dnsutils、netcat-traditional、traceroute、iputils-ping、net-tools、lsof

**容器工具**

- libcap2-bin、gosu

**传输**

- apt-transport-https

## 🔧 本地构建

### 前置要求

- Docker 20.10+ 或 Docker Desktop
- Docker Buildx（用于多架构构建）

### 构建命令

```bash
# 构建 Debian 12
docker build -t debian:12-local docker/12/

# 构建 Debian 13
docker build -t debian:13-local docker/13/

# 构建特定平台
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t debian:13-local \
  docker/13/

# 构建所有平台（需要 buildx）
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v5,linux/386,linux/ppc64le,linux/s390x,linux/riscv64 \
  -t debian:13-multi \
  docker/13/
```

## 📚 文档

- [Docker 配置指南](docker/README.md) - 详细的 docker 设置和使用
- [贡献指南](CONTRIBUTING.md) - 如何为此项目做贡献
- [更新日志](CHANGELOG.md) - 版本历史和发布说明
- [安全策略](SECURITY.md) - 安全报告和策略

## 🤝 贡献

欢迎贡献！请阅读我们的[贡献指南](CONTRIBUTING.md)了解详情：

- 行为准则
- 开发工作流程
- 提交消息约定
- Pull Request 流程

## 🔒 安全

安全是首要任务。如果您发现安全漏洞，请遵循我们的[安全策略](SECURITY.md)进行负责任的披露。

## 📄 许可证

本项目采用 **MIT 许可证**。
版权所有 (c) 2026-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
完整许可证文本请参见 [LICENSE](./LICENSE) 文件。

## 🙏 致谢

- 基于官方 [Debian Docker 镜像](https://hub.docker.com/_/debian)
- 受 Docker 社区最佳实践启发
- 使用 [GitHub Actions](https://github.com/features/actions) 构建

## 📞 支持

- 📧 邮箱：<sn0wdr1am@qq.com>
- 🐛 问题：[GitHub Issues](https://github.com/snowdreamtech/debian/issues)
- 💬 讨论：[GitHub Discussions](https://github.com/snowdreamtech/debian/discussions)

## Star History

[![Star History Chart](https://api.star-history.com/image?repos=snowdreamtech/debian&type=date&legend=top-left)](https://www.star-history.com/?repos=snowdreamtech%2Fdebian&type=date&legend=top-left)
