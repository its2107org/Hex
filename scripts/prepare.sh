#!/bin/bash
# Puts Ian's Apple team on the copied app (so it can go to his TestFlight),
# then generates the Xcode project. The copied files themselves stay untouched in git.
set -euo pipefail
: "${TEAMID:?TEAMID secret missing}"
root=$(cd "$(dirname "$0")/.." && pwd)
# Our small fixes on top of the original (patches/*.py edit the copied files at build time).
# If the original changed so a fix can't find its place, the build stops, so a fix is never lost quietly.
for p in "$root"/patches/*.py; do
  [ -e "$p" ] || continue
  (cd "$root" && python3 "$p") || { echo "::error::$(basename "$p") could not be applied to the latest original"; exit 1; }
  echo "Applied $(basename "$p")"
done

cd "$root/ios"

# App Group (registered by hand at developer.apple.com, so it has a fixed, simple name)
grep -rlI "group\.anomaly\.hex\.mobile" . | while read -r f; do
  sed -i '' "s/group\.anomaly\.hex\.mobile/group.its2107org.hex/g" "$f"
done
# anomaly.hex.mobile -> com.<team>.hex (bundle IDs, URL names)
grep -rlI "anomaly\.hex\.mobile" . | while read -r f; do
  sed -i '' "s/anomaly\.hex\.mobile/com.${TEAMID}.hex/g" "$f"
done
sed -i '' -E "s/^( +DEVELOPMENT_TEAM: ).*/\1${TEAMID}/" project.yml
sed -i '' -E "s/^( +bundleIdPrefix: ).*/\1com.${TEAMID}/" project.yml
sed -i '' "s/5NZ4Q7NXJ4/${TEAMID}/g" ExportOptions.plist

command -v xcodegen >/dev/null || brew install xcodegen
scripts/fetch-cleanup-model.sh
xcodegen generate
pins=HEXMobile.xcodeproj/project.xcworkspace/xcshareddata/swiftpm
mkdir -p "$pins"
cp Package.resolved "$pins/Package.resolved"
xcodebuild -resolvePackageDependencies -project HEXMobile.xcodeproj -scheme HEXMobile \
  -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile >/dev/null
echo "Project ready for team ${TEAMID:0:2}…"
