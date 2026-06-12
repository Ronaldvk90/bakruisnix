#!/usr/bin/env bash

docker manifest rm ronaldvk90/$0:latest 2>/dev/null || true
docker manifest create ronaldvk90/$0:latest ronaldvk90/$0:x86_64 ronaldvk90/$0:armv7 ronaldvk90/$0:aarch64

docker manifest push ronaldvk90/$0:latest

