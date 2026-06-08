{ pkgs }:

######## AVAHI container ##########
pkgs.dockerTools.buildImage {
  name = "shairport-syncnix";
  tag = "latest";
  copyToRoot = pkgs.buildEnv {
    ignoreCollisions = true;
    name = "rootfs";
    pathsToLink = ["/bin"
                              "/etc"
                             ];

  paths = with pkgs; [
  shairpot-sync
  coreutils
  bash

  (pkgs.writeShellScriptBin "entrypoint" ''
    tail -f /dev/null
    '')

#  (pkgs.runCommand "shairport-user" {} ''
#    mkdir -p $out/etc
#
#    cat > $out/etc/passwd <<EOF
#    root:x:0:0:root:/root:/bin/sh
#    shairport-sync:x:100:100:avahi:/var/empty:/sbin/nologin
#    EOF
#
#    cat > $out/etc/group <<EOF
#    root:x:0:
#    shairport-sync:x:100:
#    EOF
#    '')
    ];
  };
  

  config = {
  Env = ["PATH=/bin/"];
  Cmd = [ "entrypoint" ];
#  Healthcheck = {
#    Test = [ "CMD-SHELL" "test -S /var/run/avahi-daemon/socket || exit 1" ];
#    Interval = 5 * 1000000000;
#    Timeout = 10 * 1000000000;
#    Retries = 10;
#    };
  };
}
