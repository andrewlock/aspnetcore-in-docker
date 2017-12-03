GITSHA1=${GITSHA1:=$(git rev-parse HEAD)}
BuildNumber=${BuildNumber:=1}
DOCKER_IMAGE_VERSION=${GITSHA1}

docker build -t andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION --build-arg BuildNumber="$BuildNumber" .

# tag image with latest tag
#docker tag andrewlock/aspnetcore-in-docker:$DOCKER_IMAGE_VERSION andrewlock/aspnetcore-in-docker:latest