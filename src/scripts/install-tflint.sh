#!/usr/bin/env bash

[[ "$TRACE" ]] && set -o xtrace
set -o errexit
set -o nounset
set -o pipefail

if [[ -z "$TFLINT_VERSION" ]]; then
  echo "TFLINT_VERSION is not set. Exiting."
  exit 1
fi

wget https://github.com/terraform-linters/tflint/releases/download/v"$TFLINT_VERSION"/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip
sudo mv tflint /usr/local/bin/
tflint --version
