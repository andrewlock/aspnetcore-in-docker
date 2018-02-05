#!/bin/bash
set -eux
BUILD_NUMBER=${BUILD_NUMBER:=0.0.1}
GITSHA1=${GITSHA1:=$(git rev-parse HEAD)}
DOCKER_IMAGE_VERSION=${BUILD_NUMBER}.${GITSHA1}

docker build -t andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION .

# tag image with latest tag
#docker tag andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION andrewlock/aspnetcore-in-docker:latest
