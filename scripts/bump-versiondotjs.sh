#!/usr/bin/env bash
set -e

AT_REPO="$HOME/proj/swift/alt-tab-macos"
DAT_REPO="$HOME/proj/obj-c/DockAltTab"

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

# update xcode versions
if [[ "$TARGET" == "dat" ]]; then
  echo "Updating DockAltTab Xcode version..."

  (
    cd "$DAT_REPO"

    # Update marketing version (user-facing version (info.plist: Bundle version string (short)))    xcode proj can't use generated plist: https://stackoverflow.com/questions/72558951/agvtool-new-marketing-version-doesnt-work-on-xcode-13
    agvtool new-marketing-version "$NEW" >/dev/null

    # Increment build number automatically: Target -> General -> Identity -> 'Build' cannot be empty
    # agvtool next-version -all >/dev/null

    # agvtool bump # uses: CURRENT_PROJECT_VERSION
  )
fi

# todo: they do this already in scripts/
if [[ "$TARGET" == "at" ]]; then
  echo "Updating AltTab Xcode version..."
fi
