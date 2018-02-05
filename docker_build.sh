#!/bin/bash
set -eux
BUILD_NUMBER=${BUILD_NUMBER:=0.0.1}
GITSHA1=${GITSHA1:=$(git rev-parse HEAD)}
DOCKER_IMAGE_VERSION=${BUILD_NUMBER}.${GITSHA1}

# tarball csproj files, sln files, and NuGet.config
find . \( -name "*.csproj" -o -name "*.sln" -o -name "NuGet.config" \) -print0 \
    | tar -cvf projectfiles.tar --null -T -

docker build -t andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION .

rm projectfiles.tar
# tag image with latest tag
#docker tag andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION andrewlock/aspnetcore-in-docker:latest
