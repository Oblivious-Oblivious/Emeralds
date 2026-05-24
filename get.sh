#!/bin/sh
set -e

REPO="Oblivious-Oblivious/Emeralds"
VERSION="0.10.3"
URL="https://github.com/${REPO}/archive/refs/tags/v${VERSION}.tar.gz"

command -v crystal >/dev/null 2>&1 || {
  echo "crystal is required: https://crystal-lang.org/install/"
  exit 1
}

command -v shards >/dev/null 2>&1 || {
  echo "shards is required (install with crystal)"
  exit 1
}

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT INT HUP TERM

curl -fsSL "$URL" | tar -xz -C "$TMPDIR"
SRCDIR="$(find "$TMPDIR" -maxdepth 1 -type d -name 'Emeralds-*' | head -1)"
[ -n "$SRCDIR" ] || {
  echo "failed to find extracted source"
  exit 1
}

cd "$SRCDIR"
shards install
shards build --release --no-debug
cp bin/emeralds bin/em
cp bin/em bin/emeralds /usr/local/bin/
echo "installed em and emeralds to /usr/local/bin"
