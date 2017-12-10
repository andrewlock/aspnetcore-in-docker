GITSHA1=${GITSHA1:=$(git rev-parse HEAD)}
PackageVersion=${PackageVersion:='0.0.1'}
DOCKER_IMAGE_VERSION=${GITSHA1}

docker build -t andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION --build-arg PackageVersion="$PackageVersion" .

# tag image with latest tag
#docker tag andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION andrewlock/aspnetcore-in-docker:latest