#!/bin/bash

param_github_user=$(eval echo "\$$GITHUB_USER_ENV_VAR_NAME")
param_github_token=$(eval echo "\$$GITHUB_TOKEN_ENV_VAR_NAME")

if [ "${param_github_token}" = "" ]; then
  echo "GITHUB_TOKEN not set."
  exit 1
fi

if [ "${param_github_user}" = "" ]; then
  echo "GITHUB_USER not set."
  exit 1
fi

fetch_pr_number() {
  local pr_response
  local pr_number

  pr_response=$(curl --silent \
                    --location \
                    --request GET "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls?head=$CIRCLE_PROJECT_USERNAME:$CIRCLE_BRANCH&state=open" \
                    -u "$param_github_user":"$param_github_token")

  pr_number=$(echo "$pr_response" | jq -r ".[0].number")

  echo "$pr_number"
}

applicable_comment_ids() {
  local comments

  comments=$(fetch_comments)

  echo "$comments" | jq ".[] | select(.author.login == \"$param_github_user\") | select(.isMinimized == false) | .id"
}

fetch_comments() {
  local query
  local gql_response

  query=$(jo query="$(gql_query_for_comment)")
  pr_response=$(curl --silent \
                    --location \
                    --request POST "https://api.github.com/graphql" \
                    -u "$param_github_user":"$param_github_token" \
                    --header 'Content-Type: application/json' \
                    --header 'Accept: application/vnd.github+json' \
                    --data "$(echo "$query" | jq -c .)")

  echo "$gql_response" | jq -r ".data.repository.pullRequest.comments.nodes"
}

gql_query_for_comment() {
  local pr_number
  local fetch_comments_query

  pr_number=$(fetch_pr_number)
  fetch_comments_query="query {
    repository(owner: \"${CIRCLE_PROJECT_USERNAME}\", name: \"${CIRCLE_PROJECT_REPONAME}\") {
      pullRequest(number: ${pr_number}) {
        comments(first: 100) {
          nodes {
            id
            body
            author {
              login
            }
            createdAt
            isMinimized
            minimizedReason
          }
        }
      }
    }
  }"

  echo "$fetch_comments_query"
}

gql_mutation_for_comment() {
  local node_id
  local query

  node_id=$1

  # The enum value for OUTDATED is not configured correctly in the GraphQL schema (this is a bug
  # in the GitHub API). The value is 'outdated' rather than 'OUTDATED'
  query="mutation {
    minimizeComment(input: {subjectId: $node_id, classifier: OUTDATED}) {
      minimizedComment {
        isMinimized
      }
    }
  }"

  echo "$query"
}

mark_previous_comments_as_expired() {
  local comment_ids
  local query
  local response

  comment_ids=$(applicable_comment_ids)

  if [ -z "$comment_ids" ]; then
    echo "No applicable comments found"
  else
    echo "Minimizing comments..."

    echo "Comment IDs:"
    echo "$comment_ids"

    for node_id in $comment_ids; do
      query=$(jo query="$(gql_mutation_for_comment "$node_id")")
      response=$(curl --silent \
                      --location \
                      --request POST "https://api.github.com/graphql" \
                      -u "$param_github_user":"$param_github_token" \
                      --header 'Content-Type: application/json' \
                      --header 'Accept: application/vnd.github+json' \
                      --data "$(echo "$query" | jq -c .)")

      echo "Response:"
      echo "$response"
    done
  fi
}

mark_previous_comments_as_expired
