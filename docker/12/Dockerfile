# Debian Base Image

# Technical Purpose: High-performance, multi-architecture base image for Snowdream Tech projects.
# Design:
#   - Optimized layering for minimal image size.
#   - Decoupled initialization via entrypoint.d mechanism.
#   - Native support for PUID/PGID user mapping.
#   - Pre-installed with essential dev/ops tooling (Git, Curl, Sudo, etc.).

FROM debian:12.13-slim

# Build-time Configuration
ARG BUILDTIME \
    VERSION \
    REVISION \
    KEEPALIVE=0 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PASSWORDLESS_SUDO=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root

# Standard OCI Metadata (https://github.com/opencontainers/image-spec)
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Debian Base Image" \
    org.opencontainers.image.description="Professional Docker Image packaging for Debian Linux. Supports amd64, arm32v5, arm32v7, arm64, i386, ppc64le, riscv64, s390x." \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/debian" \
    org.opencontainers.image.base.name="snowdreamtech/debian:latest" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/debian" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="${VERSION:-12.13.0}" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/debian"

# Runtime Environment Configuration
ENV KEEPALIVE=${KEEPALIVE} \
    CAP_NET_BIND_SERVICE=${CAP_NET_BIND_SERVICE} \
    LANG=${LANG} \
    UMASK=${UMASK} \
    DEBUG=${DEBUG} \
    PASSWORDLESS_SUDO=${PASSWORDLESS_SUDO} \
    PGID=${PGID} \
    PUID=${PUID} \
    USER=${USER} \
    WORKDIR=${WORKDIR}

# Infrastructure & Tooling Setup
# Includes standard repositories and essential system packages.
RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    zsh \
    nano \
    rsync \
    lsb-release \
    sudo \
    procps \
    vim \
    zip \
    unzip \
    bzip2 \
    xz-utils \
    file \
    gzip \
    jq \
    tzdata \
    openssl \
    gnupg \
    aptitude \
    sysstat \
    wget \
    curl \
    git \
    libcap2-bin \
    gosu \
    dnsutils \
    netcat-traditional \
    traceroute \
    iputils-ping \
    net-tools \
    lsof \
    apt-transport-https \
    ca-certificates \
    && update-ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && sed -i "s|Suites:\s*bookworm\s*bookworm-updates.*|Suites: bookworm bookworm-updates bookworm-backports|g" /etc/apt/sources.list.d/debian.sources \
    && echo 'export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> /etc/bash.bashrc

# System Initialization logic (User mapping, permissions) is handled in entrypoint.d scripts.
# This keeps the Dockerfile clean and the process extensible.

# Container Orchestration Files
COPY entrypoint.d /usr/local/bin/entrypoint.d
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Ensure execution bits are correctly set for all entrypoint scripts.
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

# Standard Healthcheck (Verification of core system responsiveness)
HEALTHCHECK NONE

# Process Execution
USER root
WORKDIR /root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]
