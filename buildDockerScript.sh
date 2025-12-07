#!/bin/bash

echo "Logging into Docker"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker build -t $DOCKER_USERNAME/wtf_repo:studybud_v1 .

docker push $DOCKER_USERNAME/wtf_repo:studybud_v1
