#todo: use ./DockAltTab-sign-executable (sparkle:edSignature=, length=)


#!/usr/bin/env bash
set -e

TARGET="$1"
VERSION_FILE="version.js"

get_version() {
  KEY="$1"
  grep -E "^[[:space:]]*$KEY:" "$VERSION_FILE" \
  | sed -E 's/.*"([0-9]+\.[0-9]+\.[0-9]+)".*/\1/'
}

DATE=$(date -Ru)

if [[ "$TARGET" == "dat" ]]; then

  VERSION=$(get_version DockAltTab)
  FILE="appcast-dockalttab.xml"

  cat > /tmp/newitem.xml <<EOF
      <item>
         <title>Version $VERSION</title>
         <pubDate>$DATE</pubDate>
         <sparkle:minimumSystemVersion>11.3</sparkle:minimumSystemVersion>
         <sparkle:releaseNotesLink>https://dockalttab.netlify.app/changelog-sparkle</sparkle:releaseNotesLink>
         <enclosure
            url="https://github.com/steventheworker/DockAltTab/releases/download/v$VERSION/DockAltTab-v$VERSION.zip"
            sparkle:version="$VERSION"
            sparkle:shortVersionString="$VERSION"
            sparkle:edSignature="SIGNATURE" length="LENGTH"
            type="application/octet-stream"/>
      </item>
EOF

elif [[ "$TARGET" == "at" ]]; then

  VERSION=$(get_version AltTab)
  FILE="appcast-AltTab.xml"

  cat > /tmp/newitem.xml <<EOF
      <item>
         <title>Scriptable Version $VERSION</title>
         <pubDate>$DATE</pubDate>
         <sparkle:minimumSystemVersion>10.12</sparkle:minimumSystemVersion>
         <sparkle:releaseNotesLink>https://dockalttab.netlify.app/changelog-sparkle/</sparkle:releaseNotesLink>
         <enclosure
            url="https://github.com/steventheworker/alt-tab-macos/releases/download/$VERSION/AltTab-scriptable-$VERSION.zip"
            sparkle:version="$VERSION"
            sparkle:shortVersionString="$VERSION"
            sparkle:edSignature="SIGNATURE"
            length="LENGTH"
            type="application/octet-stream"/>
      </item>
EOF

else
  echo "Invalid target"
  exit 1
fi

# insert after <?xml><rss><channel><title><language>
sed -i '' '/<language>/r /tmp/newitem.xml' "$FILE"

rm /tmp/newitem.xml

echo "Inserted new appcast item for '$VERSION'"