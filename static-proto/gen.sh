#!/bin/sh
set -e

pandoc SampleCopy.md -o index.html -H header.html -f gfm -f markdown-implicit_figures
