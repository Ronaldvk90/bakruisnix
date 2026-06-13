#!/usr/bin/env bash

nix build .#$1-x86   -o ./$1/result-x86
nix build .#$1-arm64 -o ./$1/result-arm64
nix build .#$1-armv7 -o ./$1/result-armv7

#nix build .#compose		 -o ./docker-compose.yml
