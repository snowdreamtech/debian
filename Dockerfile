FROM debian:12.8-slim

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Debian Base Image" \
    org.opencontainers.image.description="Docker Images for Debian. (i386,amd64,arm32v5,arm32v7,arm64,mips64le,ppc64le,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/debian" \
    org.opencontainers.image.base.name="snowdreamtech/debian:latest" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/debian" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="12.8" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/debian"

ENV DEBIAN_FRONTEND=noninteractive \
    # keep the docker container running
    KEEPALIVE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/debian#locales)
    LANG=C.UTF-8 

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    lsb-release \
    procps \
    sudo \
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
    dnsutils \
    netcat-traditional \
    traceroute \
    iputils-ping \
    net-tools \
    lsof \
    apt-transport-https \
    ca-certificates \                                                                                                                                                                                                      
    && update-ca-certificates\
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && echo 'export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> /etc/bash.bashrc 

COPY vimrc.local /etc/vim/vimrc.local

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]