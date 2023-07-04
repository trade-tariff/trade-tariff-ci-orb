#!/bin/bash

cf_app=$(eval echo "\$$PARAM_CF_APP")
space=$(eval echo "\$$PARAM_SPACE")
env_key=$(eval echo "\$$PARAM_ENV_KEY")

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

# Verify healthcheck endpoint on new app
healthcheck_response=$(curl -s -o /dev/null -w "%{http_code}" \
  "https://$dark_app.london.cloudapps.digital/healthcheck")

if [ "$healthcheck_response" -ne 200 ]; then
  echo "dark route not available, failing deploy ($healthcheck_response)"
  cf logs "$dark_app" --recent
  cf delete -f "$dark_app"
  exit 1
fi

if [ "$space" == "development" ] && [ "${CYPRESS_DEVELOPMENT_BASIC_AUTH}" == "true" ]; then
  BASIC_AUTH="-u ${CYPRESS_DEVELOPMENT_BASIC_USERNAME}:${CYPRESS_DEVELOPMENT_BASIC_PASSWORD}"
elif [ "$space" == "staging" ] && [ "${CYPRESS_STAGING_BASIC_AUTH}" == "true" ]; then
  BASIC_AUTH="-u ${CYPRESS_STAGING_BASIC_USERNAME}:${CYPRESS_STAGING_BASIC_PASSWORD}"
fi

healthcheck_response=$(curl -s -o /dev/null "${BASIC_AUTH}" \
  -w "%{http_code}" \
  "https://$dark_app.london.cloudapps.digital/find_commodity")

if [ "$healthcheck_response" -ne 200 ];then
  echo "dark app home page not available, failing deploy ($healthcheck_response)"
  cf logs "$dark_app" --recent
  cf delete -f "$dark_app"
  exit 1
fi
