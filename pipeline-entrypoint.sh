#!/bin/sh
set -xe

echo "Docker action run"
apk version
which httpd

# generate a static result

bundle

mkdir -p target
cucumber -f pretty,html -o target/result.html
