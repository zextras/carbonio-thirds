#!/bin/sh
# Build only carbonio-postfix locally with yap, then check the packaged main.cf.
#
# Notes:
# - Uses yap v2.0.7, NOT the 1.48 pinned in the Makefile: 1.48's PKGBUILD
#   interpreter expands shell variables assigned inside build() (e.g. _auxlibs)
#   to empty strings, which silently drops AUXLIBS and breaks the link step.
# - Build deps (openssl/openldap/mariadb/cyrus-sasl/krb5) are not built; their
#   devel debs are downloaded and extracted into the container root, same as
#   the carbonio-mta Dockerfile does.
# - yap v2 writes artifacts to /tmp/artifacts inside the container, mounted
#   here onto ./artifacts.
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
YAP_IMAGE="docker.io/m0rf30/yap-ubuntu-jammy:v2.0.7"
TARGET="ubuntu-jammy"
DEVEL_REPO="deb [trusted=yes] https://repo.area51-zextras.com/devel/ubuntu jammy main"

mkdir -p "$REPO_DIR/artifacts" "$REPO_DIR/.ccache"

podman run --rm --user root --name yap-postfix-local \
  -v "$REPO_DIR":/project \
  -v "$REPO_DIR/artifacts":/tmp/artifacts \
  -v "$REPO_DIR/.ccache":/root/.ccache \
  -e CCACHE_DIR=/root/.ccache \
  --entrypoint bash "$YAP_IMAGE" -c "
set -ex
echo '$DEVEL_REPO' > /etc/apt/sources.list.d/zextras-devel.list
apt-get update -qq
cd /tmp
apt-get download carbonio-openssl carbonio-openldap carbonio-mariadb carbonio-cyrus-sasl carbonio-krb5
for d in /tmp/*.deb; do dpkg -x \"\$d\" /; done
yap prepare $TARGET
yap build $TARGET /project --from carbonio-postfix --to carbonio-postfix
"

DEB=$(ls -t "$REPO_DIR"/artifacts/carbonio-postfix_*.deb | head -1)
CHECK_DIR=$(mktemp -d)
trap 'rm -rf "$CHECK_DIR"' EXIT
dpkg-deb -x "$DEB" "$CHECK_DIR"
MAIN_CF="$CHECK_DIR/opt/zextras/common/conf/main.cf"

echo
echo "=== $DEB"
echo "=== sample_directory in packaged main.cf:"
grep -nE '^#? *sample_directory' "$MAIN_CF" || echo "(no sample_directory line)"
echo "=== empty install parameters (must be none):"
if grep -nE '^[a-z_]+_(directory|path|owner|group) *= *$' "$MAIN_CF"; then
  echo "BROKEN: empty install parameter(s) found"
  exit 1
fi
echo "none - package OK"
