#!/bin/sh
set -xe

echo "Docker action run"
apk version
which httpd

# generate a static result

bundle

mkdir -p target
cucumber -f pretty -f html -o target/index.html
sed -i "s/$SECRET/***/g" target/index.html
git config --global safe.directory '*'
gh secrets list
