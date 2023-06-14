#!/bin/sh
set -xe

echo "Docker action run"
apk version
which httpd

# generate a static result

mkdir -p target
echo "Success" > target/index.html
