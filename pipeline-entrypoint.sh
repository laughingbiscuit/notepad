#!/bin/sh
set -xe

bundle

mkdir -p target
cucumber -f pretty -f html -o target/index.html

# remove secrets from report
for SOME_SECRET in "$(cat .github/workflows/pipeline.yml | yq -r '.jobs[].steps[].env[]' | grep -o 'secret.* ' | sed 's/secrets\.//')"; do
  sed -i "s/$SOME_SECRET/***/g" target/index.html
done

