#!/bin/bash

# Container name
CONTAINER_NAME="studybud_app"
IMAGE_NAME="cloudqween/wtf_repo:studybud_v1"

# Path to persistent SQLite file on EC2
SQLITE_HOST_PATH="/home/ubuntu/sqlite/db.sqlite3"
SQLITE_CONTAINER_PATH="/app/db.sqlite3"  # inside container

echo "Pulling the Docker image for deployment"
docker pull $IMAGE_NAME

# Stop old container if it exists
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "Starting new container"
docker run -d \
  --name $CONTAINER_NAME \
  -v $SQLITE_HOST_PATH:$SQLITE_CONTAINER_PATH \
  -p 9000:8000 \
  $IMAGE_NAME

echo "Deployment is successful"
