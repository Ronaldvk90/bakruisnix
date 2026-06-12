#!/usr/bin/env bash

docker manifest rm $0:latest 2>/dev/null || true
docker manifest create $0:latest $0:x86_64 $0:armv7 $0:aarch64

docker manifest push $0:latest

