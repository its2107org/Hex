#!/bin/bash
# Picks the newest non-beta Xcode on the build machine.
set -euo pipefail
xcode=$(ls -d /Applications/Xcode_*.app | grep -vi beta | sort -V | tail -1)
sudo xcode-select --switch "$xcode/Contents/Developer"
echo "::notice::Using $(basename "$xcode")"
