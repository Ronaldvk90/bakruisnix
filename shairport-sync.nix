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
  shairport-sync
  gnused
  nqptp

  (pkgs.writeShellScriptBin "entrypoint" ''
    echo "creating /tmp"
    mkdir /tmp

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
#  Healthcheck = {
#    Test = [ "CMD-SHELL" "test -S /var/run/avahi-daemon/socket || exit 1" ];
#    Interval = 5 * 1000000000;
#    Timeout = 10 * 1000000000;
#    Retries = 10;
#    };
  };
}
