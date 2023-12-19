#!/bin/sh

CARGO_TOML="${TRUNK_SOURCE_DIR}/Cargo.toml"
INDEX_HTML="${TRUNK_STAGING_DIR}/index.html"

DEFAULT_VERSION_STRING="0.0.0"
DEFAULT_BUILD_NUMBER="0"

# Derive version from Cargo.toml as fallback if VERSION_STRING is not set
CARGO_PKG_VERSION="$(grep -Po "^version\s+=\s+\"\K\d\.\d\.\d" $CARGO_TOML)"

# Set default values if variables are not yet set.
BUILD_NUMBER="${BUILD_NUMBER:-${DEFAULT_BUILD_NUMBER}}"
VERSION_STRING="${CARGO_PKG_VERSION:-${DEFAULT_VERSION_STRING}}"

# Omit BUILD_METADATA when running within GitHub Actions.
if [ "${GITHUB_ACTIONS}" = "true" ]; then
  BUILD_METADATA="";
else
  BUILD_METADATA="local";
fi

echo "Build metadata: $BUILD_METADATA"
echo "Build number: $BUILD_NUMBER"
echo "Version string: $VERSION_STRING"

# Concat the build string.
if [ -n "${BUILD_METADATA}" ]; then
  BUILD_STRING="${VERSION_STRING}-${BUILD_NUMBER}+${BUILD_METADATA}";
else
  BUILD_STRING="${VERSION_STRING}-${BUILD_NUMBER}";
fi

echo "Build string: $BUILD_STRING"

# Search and replace {{ BUILD_STRING }} with BUILD_STRING
sed -i "s/{{ BUILD_STRING }}/${BUILD_STRING}/g" ${INDEX_HTML}
