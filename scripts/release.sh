#!/usr/bin/env bash
set -e

TYPE="$1"
TARGET="$2"

if [[ -z "$TYPE" || -z "$TARGET" ]]; then
  echo "Usage: ./scripts/release.sh <patch|minor|major> <at|dat>"
  exit 1
fi

echo "Release type: $TYPE"
echo "Target: $TARGET"

./scripts/bump-versiondotjs.sh "$TYPE" "$TARGET"
# todo: export xcode archive, zip it, rename it
./scripts/update-appcast.sh "$TARGET"

# future steps
# ./scripts/create-git-tag.sh "$TARGET"
node ./scripts/update-readme.js
# push DAT/AT repo's
# push this repo

echo "Release pipeline complete"