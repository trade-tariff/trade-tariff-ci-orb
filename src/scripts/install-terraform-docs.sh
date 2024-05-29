#!/usr/bin/env bash

[[ "$TRACE" ]] && set -o xtrace
set -o errexit
set -o nounset
set -o pipefail

if [[ -z "${TERRAFORM_DOCS_VERSION}" ]]; then
  echo "TERRAFORM_DOCS_VERSION is not set. Exiting."
  exit 1
fi

wget https://github.com/terraform-docs/terraform-docs/releases/download/v"$TERRAFORM_DOCS_VERSION/terraform-docs-v$TERRAFORM_DOCS_VERSION"-linux-amd64.tar.gz

tar -xzf terraform-docs-v"$TERRAFORM_DOCS_VERSION"-linux-amd64.tar.gz

sudo mv terraform-docs /usr/local/bin/

terraform-docs --version
