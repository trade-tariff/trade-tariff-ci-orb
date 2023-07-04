#!/bin/bash

cf_app=$(eval echo "\$$PARAM_CF_APP")
space=$(eval echo "\$$PARAM_SPACE")
env_key=$(eval echo "\$$PARAM_ENV_KEY")
path=$(eval echo "\$$HEALTHCHECK_PATH")

dark_app="$cf_app-$env_key-dark"

if [ "${cf_app}" = "" ]; then
  echo "cf_app parameter not set."
  exit 1
fi

if [ "${space}" = "" ]; then
  echo "space parameter not set."
  exit 1
fi

if [ "${env_key}" = "" ]; then
  echo "environment_key parameter not set."
  exit 1
fi

if [ "${path}" = "" ]; then
  echo "healthcheck_path parameter not set."
  exit 1
fi

# Verify healthcheck endpoint on new app
healthcheck_response=$(curl -s -o /dev/null -w "%{http_code}" \
  "https://$dark_app.london.cloudapps.digital/${path}")

if [ "$healthcheck_response" -ne 200 ]; then
  echo "dark route not available, failing deploy ($healthcheck_response)"
  cf logs "$dark_app" --recent
  cf delete -f "$dark_app"
  exit 1
fi
