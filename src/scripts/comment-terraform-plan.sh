PARAM_GITHUB_USER=$(eval echo "\$$GITHUB_USER_ENV_VAR_NAME")
PARAM_GITHUB_TOKEN=$(eval echo "\$$GITHUB_TOKEN_ENV_VAR_NAME")

if [ "${PARAM_GITHUB_TOKEN}" = "" ]; then
  echo "GITHUB_TOKEN not set."
  exit 1
fi

if [ "${PARAM_GITHUB_USER}" = "" ]; then
  echo "GITHUB_USER not set."
  exit 1
fi

if [ "${PARAM_PLAN}" = "" ]; then
  echo "No terraform plan output provided."
  exit 1
fi

PR_RESPONSE=$(curl --location --request GET "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls?head=$CIRCLE_PROJECT_USERNAME:$CIRCLE_BRANCH&state=open" \
-u "$PARAM_GITHUB_USER":"$PARAM_GITHUB_TOKEN")

if [ "$(echo "${PR_RESPONSE}" | jq length)" -eq 0 ]; then
  echo "No PR found to update, skipping."
  # Exit 0 to not error and stop the workflow.
  exit 0
fi

COMMENT=$(jo body="\`\`\`\n$(terraform show -no-color "${PARAM_PLAN}")")

PR_COMMENT_URL=$(echo "${PR_RESPONSE}" | jq --raw-output ".[]._links.comments.href")

curl --location --request POST "${PR_COMMENT_URL}" \
-u "${PARAM_GITHUB_USER}":"${PARAM_GITHUB_TOKEN}" \
--header 'Content-Type: application/json' \
--data-raw "${COMMENT}"

exit 0
