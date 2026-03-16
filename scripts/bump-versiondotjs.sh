#!/usr/bin/env bash
set -e

TYPE="$1"
TARGET="$2"
FILE="version.js"

case "$TARGET" in
  dat) KEY="DockAltTab" ;;
  at)  KEY="AltTab" ;;
  *)
    echo "Target must be: dat | at"
    exit 1
    ;;
esac

# extract only the correct line
LINE=$(grep -E "^[[:space:]]*$KEY:" "$FILE")

CURRENT=$(echo "$LINE" | sed -E 's/.*"([0-9]+\.[0-9]+\.[0-9]+)".*/\1/')

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$TYPE" in
  patch)
    PATCH=$((PATCH+1))
    ;;
  minor)
    MINOR=$((MINOR+1))
    PATCH=0
    ;;
  major)
    MAJOR=$((MAJOR+1))
    MINOR=0
    PATCH=0
    ;;
  *)
    echo "Type must be patch|minor|major"
    exit 1
    ;;
esac

NEW="$MAJOR.$MINOR.$PATCH"

echo "$KEY: $CURRENT → $NEW"

sed -i '' "s/$KEY: \"$CURRENT\"/$KEY: \"$NEW\"/" "$FILE"