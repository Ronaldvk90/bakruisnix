{ pkgs. arch }:

######## AVAHI container ##########
pkgs.dockerTools.buildImage {
  name = "ronaldvk90/avahinix";
  tag = arch;
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

  (pkgs.writeShellScriptBin "entrypoint" ''
    ## Make sure there is no pidfile, or else the daemon won't start
    mkdir -p /run/avahi-daemon
    rm -rf /var/run/avahi-daemon/pid

    ## Avahi actual entrypoint
    avahi-daemon
    '')

  (pkgs.runCommand "avahi-users" {} ''
    mkdir -p $out/etc

    cat > $out/etc/passwd <<EOF
    root:x:0:0:root:/root:/bin/sh
    avahi:x:100:100:avahi:/var/empty:/sbin/nologin
    EOF

    cat > $out/etc/group <<EOF
    root:x:0:
    avahi:x:100:
    EOF
    '')
    ];
  };
  

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
