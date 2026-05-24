#!/bin/sh
set -e

REPO="Oblivious-Oblivious/Emeralds"
VERSION="0.10.11"
URL="https://github.com/${REPO}/archive/refs/tags/v${VERSION}.tar.gz"

install_crystal() {
  command -v crystal >/dev/null 2>&1 && return 0

  echo "get.sh: installing crystal"
  if command -v brew >/dev/null 2>&1; then
    brew install crystal
  elif [ "$(id -u)" -eq 0 ]; then
    curl -fsSL https://crystal-lang.org/install.sh | bash
  else
    curl -fsSL https://crystal-lang.org/install.sh | sudo bash
  fi
}

install_crystal

command -v git >/dev/null 2>&1 || {
  echo "git is required"
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
echo "run with 'em help' or 'emeralds help'"
