#!/bin/bash

app=$1
environment=$2
environment_key=$3

cf_app="$app-$environment_key-dark"

# Verify healthcheck endpoint on new app
healthcheck_response=$(curl -s -o /dev/null -w "%{http_code}" \
  "https://$cf_app.london.cloudapps.digital/healthcheck")

if [ "$healthcheck_response" -ne 200 ]; then
  echo "dark route not available, failing deploy ($healthcheck_response)"
  cf logs "$cf_app" --recent
  cf delete -f  "$cf_app"
  exit 1
fi

if [ "$environment" == "development" ] && [ "${CYPRESS_DEVELOPMENT_BASIC_AUTH}" == "true" ]; then
  BASIC_AUTH="-u ${CYPRESS_DEVELOPMENT_BASIC_USERNAME}:${CYPRESS_DEVELOPMENT_BASIC_PASSWORD}"
elif [ "$environment" == "staging" ] && [ "${CYPRESS_STAGING_BASIC_AUTH}" == "true" ]; then
  BASIC_AUTH="-u ${CYPRESS_STAGING_BASIC_USERNAME}:${CYPRESS_STAGING_BASIC_PASSWORD}"
fi

healthcheck_response=$(curl -s -o /dev/null "${BASIC_AUTH}" \
  -w "%{http_code}" \
  "https://$cf_app.london.cloudapps.digital/find_commodity")

if [ "$healthcheck_response" -ne 200 ];then
  echo "dark app home page not available, failing deploy ($healthcheck_response)"
  cf logs "$cf_app" --recent
  cf delete -f "$cf_app"
  exit 1
fi
