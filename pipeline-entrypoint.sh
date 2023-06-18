#!/bin/sh
set -xe

bundle

mkdir -p target
cucumber -f pretty -f html -o target/index.html

cat .github/workflows/pipeline.yml | yq -r '.jobs[].steps[].env[]' | grep -o 'secret.* ' | sed 's/secrets\.//' | while read SOME_SECRET; do
  ! grep -q $(eval "echo $"$SOME_SECRET"") target/index.html
done
