{ pkgs }:

let
  shairportConfig = pkgs.runCommand "shairport-config" {} ''
    mkdir -p $out/etc

    cp ${./shairport-sync/shairport-sync.conf} $out/etc/shairport-sync.conf
  '';
in


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
  shairport-sync
  procps
  coreutils
  gnused
  nqptp
  bash
  shairportConfig  

  (pkgs.writeShellScriptBin "entrypoint" ''
    echo "creating /tmp"
    mkdir /tmp
    chmod 777 /tmp

    echo "Starting nqptp"
    nqptp&

    #Set the hostname
    sed -i "s/\<NAME\>/$NAME/" /etc/shairport-sync.conf

    echo "Starting shairport-sync"
    # pass all commandline options to shairport-sync
    shairport-sync "$@"
    '')
    ];
  };
  

  config = {
  Env = ["PATH=/bin/"];
  Cmd = [ "entrypoint" ];
  Healthcheck = {
    Test = [ "CMD-SHELL" "pgrep shairport-sync > /dev/null || exit 1" ];
    Interval = 5 * 1000000000;
    Timeout = 10 * 1000000000;
    Retries = 10;
    };
  };
}
