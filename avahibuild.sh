#!/usr/bin/env bash 
nix-build bakruis.test.nix --argstr system x86_64-linux -o result-amd64
nix-build bakruis.test.nix --argstr system aarch64-linux -o result-arm64
nix-build bakruis.test.nix --argstr system armv7l-linux -o result-armv7
#nix-build bakruis.armv7.nix -o result-armv7

docker load < result-amd64
docker tag dbusnix:latest ronaldvk90/dbusnix:amd64
docker load < result-arm64
docker tag dbusnix:latest ronaldvk90/dbusnix:arm64
docker load < result-armv7
docker tag dbusnix:latest ronaldvk90/dbusnix:armv7
docker image rm dbusnix:latest

docker push ronaldvk90/dbusnix:amd64
docker push ronaldvk90/dbusnix:arm64
docker push ronaldvk90/dbusnix:armv7

#docker manifest rm ronaldvk90/dbusnix:latest || true
#docker manifest create ronaldvk90/dbusnix:latest \
#	ronaldvk90/dbusnix:amd64 \
#	ronaldvk90/dbusnix:arm64 \
#	ronaldvk90/dbusnix:armv7
#docker manifest push ronaldvk90/dbusnix:latest
