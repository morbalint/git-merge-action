#!/usr/bin/env bats

BASEDIR=$(dirname "$1")

act()
{
  CONTAINER=$(docker build -q "$BASEDIR")
  docker run --rm \
  -e "INPUT_SOURCE=$1" \
  -e "INPUT_TARGET=$2" \
  -e "INPUT_DRY_RUN=true" \
  -e "INPUT_TOKEN=$GITHUB_TOKEN" \
  -e "GITHUB_SERVER_URL=https://github.com" \
  -e "GITHUB_REPOSITORY=morbalint/git-merge-action" \
  "$CONTAINER"
}

@test "merge A into B creates a merge commit" {
  result="$(act 'test/branch-A' 'test/branch-B')"
  echo "$result"
  echo "$result" | grep "branch-A\.txt | 1 \+"
}

@test "merge test/conflict-theirs into test/conflict-our with strategy option 'ours' resolves conflict automatically" {
  result="$(act 'test/conflict-theirs' 'test/conflict-ours')"
  echo "$result"
  echo "$result" | grep ".*"
}