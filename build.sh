#!/bin/sh

DOCKER_HUB_PROJECT=snowdreamtech/debian

GITHUB_PROJECT=ghcr.io/snowdreamtech/debian

docker buildx build --platform=linux/386,linux/amd64,linux/arm/v5,linux/arm/v7,linux/arm64,linux/mips64le,linux/ppc64le,linux/s390x \
-t ${DOCKER_HUB_PROJECT}:latest \
-t ${DOCKER_HUB_PROJECT}:12.7 \
-t ${DOCKER_HUB_PROJECT}:12 \
-t ${GITHUB_PROJECT}:latest \
-t ${GITHUB_PROJECT}:12.7 \
-t ${GITHUB_PROJECT}:12 \
. \
--push
