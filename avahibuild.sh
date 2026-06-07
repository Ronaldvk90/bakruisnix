#!/usr/bin/env bash 

nix-build avahinix.nix --argstr system x86_64-linux -o result-amd64
nix-build avahinix.nix --argstr system aarch64-linux -o result-arm64
nix-build avahinix.nix --argstr system armv7l-linux -o result-armv7

docker load < result-amd64
docker tag avahinix:latest ronaldvk90/avahinix:amd64
docker load < result-arm64
docker tag avahinix:latest ronaldvk90/avahinix:arm64
docker load < result-armv7
docker tag avahinix:latest ronaldvk90/avahinix:armv7
docker image rm avahinix:latest

docker push ronaldvk90/avahinix:amd64
docker push ronaldvk90/avahinix:arm64
docker push ronaldvk90/avahinix:armv7

#docker manifest rm ronaldvk90/avahinix:latest || true
#docker manifest create ronaldvk90/avahinix:latest \
#	ronaldvk90/avahinix:amd64 \
#	ronaldvk90/avahinix:arm64 \
#	ronaldvk90/avahinix:armv7
#docker manifest push ronaldvk90/avahinix:latest
