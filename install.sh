#!/bin/sh

rm -rf bin
shards build --release --no-debug
cp bin/emeralds bin/em
cp bin/em bin/emeralds /usr/local/bin/
