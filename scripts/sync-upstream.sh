#!/bin/bash
# Copies the latest iPhone app from the original Hex (anomalyco/hex, "dev" branch)
# into this repository. Prints changed=true|false for the workflow.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
git clone -q --depth 1 --branch "${UPSTREAM_BRANCH:-dev}" https://github.com/anomalyco/hex "$work/hex"
sha=$(git -C "$work/hex" rev-parse HEAD)

rm -rf "$root/ios" "$root/app/AppIcon.icon"
mkdir -p "$root/app" "$root/tests/fixtures/vocabulary/audio"
cp -R "$work/hex/ios" "$root/ios"
cp -R "$work/hex/app/AppIcon.icon" "$root/app/AppIcon.icon"
cp "$work/hex/tests/fixtures/vocabulary/audio/term-hex-1.wav" "$root/tests/fixtures/vocabulary/audio/"
cp "$work/hex/LICENSE" "$root/LICENSE"
echo "$sha" > "$root/UPSTREAM_COMMIT"

cd "$root"
if [ -n "$(git status --porcelain -- ios app tests LICENSE)" ]; then
  echo "changed=true"
else
  echo "changed=false"
fi
echo "upstream=$sha"
