#!/bin/bash

docker_tag=$(git rev-parse --short HEAD)
RELEASE_VERSION=$(< "$RELEASE_FILE")

if [ -z "${IMAGE_NAME}" ]; then
  echo "Missing IMAGE_NAME"
  exit 1
fi

if [ -z "${ECR_REPO}" ]; then
  echo "Missing ECR_REPO"
  exit 1
fi

if [ -z "${RELEASE_VERSION}" ]; then
  echo "Missing RELEASE_VERSION"
  exit 1
fi

echo "RELEASE_VERSION is '${RELEASE_VERSION}'"

DOCKER_IMAGE="${ECR_REPO}/${IMAGE_NAME}"
IMAGE_TAG="release-${RELEASE_VERSION}"

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin "$ECR_REPO"
docker pull "${DOCKER_IMAGE}:${docker_tag}"
docker tag "${DOCKER_IMAGE}:${docker_tag}" "${DOCKER_IMAGE}:${IMAGE_TAG}"
docker push "${DOCKER_IMAGE}:${IMAGE_TAG}"
