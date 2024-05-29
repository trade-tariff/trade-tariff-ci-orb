#!/usr/bin/env bash

[[ "$TRACE" ]] && set -o xtrace
set -o errexit
set -o nounset
set -o pipefail

if [[ -z "$TERRAFORM_VERSION" ]]; then
  echo "TERRAFORM_VERSION is not set. Exiting."
  exit 1
fi

if [[ -z "$TERRAFORM_ROOT" ]]; then
  echo "TERRAFORM_ROOT is not set. Exiting. This tells us where to initialise the backend"
  exit 1
fi

mkdir /tmp/build-terraform

pushd /tmp/build-terraform

wget https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}"_linux_amd64.zip

unzip terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip

# Install terraform into the PATH
sudo mv terraform /usr/local/bin/

popd

# Validate installation
terraform --version

# Configure the backend
pushd "$TERRAFORM_ROOT"
terraform init -backend=false
popd
