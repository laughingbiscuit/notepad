#!/bin/sh
set -xe

bundle

mkdir -p target
cucumber -f pretty -f html -o target/index.html

