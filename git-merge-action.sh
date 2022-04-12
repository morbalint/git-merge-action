#!/bin/sh

set -eux

INPUT_SOURCE=${INPUT_TARGET:-${GITHUB_REF##*/}}
INPUT_USER_EMAIL=${INPUT_USER_EMAIL:-git-merge-action@${GITHUB_SERVER_URL#*//}}
INPUT_USER_NAME=${INPUT_USER_NAME:-git merge action}
INPUT_DRY_RUN=${INPUT_DRY_RUN:-false}

echo "SOURCE=$INPUT_SOURCE"
echo "TARGET=$INPUT_TARGET"
echo "USER_EMAIL=$INPUT_USER_EMAIL"
echo "USER_NAME=$INPUT_USER_NAME"
echo "DRY_RUN=$INPUT_DRY_RUN"

mkdir /git-merge-action-temp && cd /git-merge-action-temp
git init -q
git config --local user.email "${INPUT_USER_EMAIL}"
git config --local user.name "${INPUT_USER_NAME}"
git remote add --fetch \
  --track "$INPUT_SOURCE" \
  --track "$INPUT_TARGET" \
  origin \
  "https://x-access-token:$INPUT_TOKEN@${GITHUB_SERVER_URL#*//}/${GITHUB_REPOSITORY}.git"

git switch "$INPUT_TARGET"
git merge "origin/$INPUT_SOURCE" -m "merge $INPUT_SOURCE into $INPUT_TARGET"

if [ "$INPUT_DRY_RUN" = "true" ]
then
  git push --dry-run origin
else
  git push origin
fi
