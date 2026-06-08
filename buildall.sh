#!/usr/bin/env bash

nix build .#dbus-x86   -o result-dbus-x86
nix build .#dbus-arm64 -o result-dbus-arm64
nix build .#dbus-armv7 -o result-dbus-armv7

nix build .#avahi-x86   -o result-avahi-x86
nix build .#avahi-arm64 -o result-avahi-arm64
nix build .#avahi-armv7 -o result-avahi-armv7
