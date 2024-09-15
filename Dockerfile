FROM alpine:3.20.3

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

# keep the docker container running
ENV KEEPALIVE=0

RUN echo "@main https://dl-cdn.alpinelinux.org/alpine/edge/main" | tee -a /etc/apk/repositories \
    && echo "@community https://dl-cdn.alpinelinux.org/alpine/edge/community" | tee -a /etc/apk/repositories \
    && echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" | tee -a /etc/apk/repositories \
    && apk add --no-cache musl-locales \
    musl-locales-lang \
    tzdata \
    openssl \
    wget \
    ca-certificates \                                                                                                                                                                                                      
    && update-ca-certificates

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]