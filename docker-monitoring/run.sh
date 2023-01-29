#!/bin/bash
# Create image at Dockerfile
docker build -t learning-docker:docker-monitoring .

# Create container with docker-compose
docker-compose up -d