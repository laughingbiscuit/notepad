#!/bin/sh
set -xe
(cd uml && java -jar /opt/plantuml.jar -tsvg *.uml)
