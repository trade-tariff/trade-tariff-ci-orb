#!/bin/bash

dark_app="${PARAM_CF_APP}-${PARAM_ENV_KEY}-dark"

# Verify healthcheck endpoint on new app
healthcheck_response=$(curl -s -o /dev/null -w "%{http_code}" \
  "https://$dark_app.${DOMAIN}/${HEALTHCHECK_PATH}")

if [ "$healthcheck_response" -ne 200 ]; then
  echo "dark route not available, failing deploy ($healthcheck_response)"
  cf logs "$dark_app" --recent
  cf delete -f "$dark_app"
  exit 1
fi
