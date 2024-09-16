FROM debian:12.7-slim

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

# keep the docker container running
ENV KEEPALIVE=0 \
    DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
        apt-get -qqy update && \
    apt-get -qqy install --no-install-recommends \ 
    sudo \
    vim \ 
    unzip \
    tzdata \
    openssl \
    wget \
    curl \
    apt-transport-https \
    ca-certificates \                                                                                                                                                                                                      
    && update-ca-certificates\
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]