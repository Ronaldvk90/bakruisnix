#!/usr/bin/env bash

nix build .#$1-x86   -o ./dbus/result-x86
nix build .#$1-arm64 -o ./dbus/result-arm64
nix build .#$1-armv7 -o ./dbus/result-armv7

#nix build .#compose		 -o ./docker-compose.yml
