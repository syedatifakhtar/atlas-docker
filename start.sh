#!/bin/sh

docker run --detach \
    -v ${PWD}/data:/opt/apache-atlas-3.0.0-SNAPSHOT/data \
    -p 21000:21000 \
    --name atlas \
    atif/apache-atlas:latest  \
    /opt/apache-atlas-3.0.0-SNAPSHOT/bin/atlas_start.py
  