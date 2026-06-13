{ pkgs, arch }:

######## Pulseaudio container ##########
pkgs.dockerTools.buildImage {
  name = "ronaldvk90/pulseaudionix";
  tag = arch;
  copyToRoot = pkgs.buildEnv {
    ignoreCollisions = true;
    name = "rootfs";
    pathsToLink = ["/bin"
                   "/etc"
                  ];

  paths = with pkgs; [
    bash
    coreutils
    procps
    pulseaudio

  (pkgs.writeShellScriptBin "entrypoint" ''
    ## Start pulseaudio
    pulseaudio -v --exit-idle-time=-1 --disallow-exit=yes
    '')

#  (pkgs.runCommand "avahi-users" {} ''
#    mkdir -p $out/etc
#
#    cat > $out/etc/passwd <<EOF
#    root:x:0:0:root:/root:/bin/sh
#    avahi:x:100:100:avahi:/var/empty:/sbin/nologin
#    EOF
#
#    cat > $out/etc/group <<EOF
#    root:x:0:
#    avahi:x:100:
#    EOF
#    '')
#    ];
#  };
  

  config = {
  Env = ["PATH=/bin/"];
  Cmd = [ "entrypoint" ];
  Healthcheck = {
    Test = [ "CMD-SHELL" "pgrep pulseaudio > /dev/null || exit 1" ];
    Interval = 5 * 1000000000;
    Timeout = 10 * 1000000000;
    Retries = 10;
    };
  };
}
