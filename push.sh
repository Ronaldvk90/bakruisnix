#!/usr/bin/env bash

echo "Loading in the docker images" 
docker load < dbus/result-x86
#docker load < $1/result-x86
docker load < dbus/result-armv7
#docker load < $1/result-armv7
#docker load < $1/result-arm64
docker load < dbus/result-arm64

echo "pusing induvidable images"
docker push ronaldvk90/$1:x86_64
docker push ronaldvk90/$1:armv7
docker push ronaldvk90/$1:aarch64

echo "deleting and recreating the manifest"
docker manifest rm ronaldvk90/$1:latest 2>/dev/null || true
docker manifest create ronaldvk90/$1:latest ronaldvk90/$1:x86_64 ronaldvk90/$1:armv7 ronaldvk90/$1:aarch64

echo "push the new manifest"
docker manifest push ronaldvk90/$1:latest

