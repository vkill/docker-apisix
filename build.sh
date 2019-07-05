#!/usr/bin/env bash

set -ex

script_path=$(cd $(dirname $0) ; pwd -P)
script_path_root="${script_path}/"

docker build \
  -t apisix:dev-alpine \
  --build-arg APISIX_VERSION=master \
  --build-arg APISIX_DOWNLOAD_SHA256=SKIP \
  -f "${script_path_root}alpine/Dockerfile" \
  "${script_path_root}alpine"

docker build \
  -t apisix:v0.5-alpine \
  -f "${script_path_root}alpine/Dockerfile" \
  "${script_path_root}alpine"
