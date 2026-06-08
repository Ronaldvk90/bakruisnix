#!/usr/bin/env bash

nix build .#dbus-x86   -o ./dbus/result-x86
nix build .#dbus-arm64 -o ./dbus/result-arm64
nix build .#dbus-armv7 -o ./dbus/result-armv7

nix build .#avahi-x86   -o ./avahi/result-x86
nix build .#avahi-arm64 -o ./avahi/result-arm64
nix build .#avahi-armv7 -o ./avahi/result-armv7

nix build .#shairport-sync-x86   -o ./shairport-sync/result-x86
nix build .#shairport-sync-arm64 -o ./shairport-sync/result-arm64
nix build .#shairport-sync--armv7 -o ./shairport-sync/result-armv7
