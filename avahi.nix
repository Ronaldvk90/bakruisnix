{ system ? builtins.currentSystem }:

let

  pkgs =
    if system == "armv7l-linux"
    then
      (import <nixpkgs> {
        system = "x86_64-linux";
      }).pkgsCross.armv7l-hf-multiplatform
  else import <nixpkgs> {
    inherit system;
  }; 
in

######## DBUS container ##########
pkgs.dockerTools.buildImage {
  name = "avahinix";
  tag = "latest";
  copyToRoot = pkgs.buildEnv {
    ignoreCollisions = true;
    name = "rootfs";
    pathsToLink = ["/bin"
                              "/etc"
                             ];

  paths = with pkgs; [
    (pkgs.avahi.overrideAttrs (old: {
    postInstall = ''
    rm $out/etc/avahi/services/*
  ''; }))
    bash
    coreutils

  (pkgs.writeShellScriptBin "entrypoint" ''
    ## Make sure there is no pidfile, or else the daemon won't start
    mkdir -p /run/avahi-daemon
    rm -rf /var/run/avahi-daemon/pid

    ## Avahi actual entrypoint
    avahi-daemon
    '')
    ]; 
  }; 

#  runAsRoot = ''
#    #!${pkgs.runtimeShell}
#    ${pkgs.dockerTools.shadowSetup}
#    groupadd -r avahi
#    useradd -r -g avahi avahi
#    mkdir -p /run/avahi-daemon
#  '';

  config = {
  Env = ["PATH=/bin/"];
  Cmd = [ "entrypoint" ];
  Healthcheck = {
    Test = [ "CMD-SHELL" "test -S /var/run/avahi-daemon/socket || exit 1" ];
    Interval = 5 * 1000000000;
    Timeout = 10 * 1000000000;
    Retries = 10;
    };
  };
}
