#!/bin/bash

docker_tag=$(git rev-parse --short HEAD)
container="${IMAGE_NAME}-${ENVIRONMENT}:${docker_tag}"

function fetch_ecr_url {
  json=$(aws ssm get-parameter \
  --name "${SSM_PARAMETER}"    \
  --with-decryption            \
  --output json                \
  --color off)

  output=$(jq -r .Parameter.Value <<< "${json}")

  if [ -n "${output}" ]; then
    echo "${output}"
  else
    exit 1
  fi
}

ecr_url=$(fetch_ecr_url)

git rev-parse --short HEAD > REVISION

docker build -t "$container" .
docker tag "${container}" "${ecr_url}:${docker_tag}"

aws ecr get-login-password | docker login --username AWS --password-stdin "${ecr_url}"

docker push "${ecr_url}:${docker_tag}"
