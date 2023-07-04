#!/bin/bash

sentry_version="1.75.2"

curl -sL -o /usr/local/bin/sentry-cli \
  "https://github.com/getsentry/sentry-cli/releases/download/${sentry_version}/sentry-cli-Linux-x86_64"

chmod 0755 /usr/local/bin/sentry-cli

SENTRY_RELEASE=$(sentry-cli releases propose-version)

sentry-cli releases new -p $SENTRY_PROJECT $SENTRY_RELEASE &&
  sentry-cli releases set-commits $SENTRY_RELEASE --auto &&
  sentry-cli releases finalize $SENTRY_RELEASE &&
  sentry-cli releases deploys $SENTRY_RELEASE new -e $SENTRY_ENVIRONMENT ||
  /usr/bin/true # prevent sentry outage from blocking deploys - see HOTT-1570
