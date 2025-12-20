#!/bin/bash
docker pull dockerhub254/group-h-python-app:latest
docker stop app || true
docker rm app || true
docker run -d -p 8000:8000 --name app dockerhub254/group-h-python-app:latest
