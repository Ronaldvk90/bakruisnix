{ pkgs, arch }:

######## DBUS container ##########
pkgs.dockerTools.buildImage {
  name = "ronaldvk90/bluetooth";
  tag = arch;
  copyToRoot = pkgs.buildEnv {
    ignoreCollisions = true;
    name = "rootfs";
    pathsToLink = ["/bin"
                   "/etc"
                  ];

  paths = with pkgs; [
  bluez
  bluez-tools
  procps
  bash

  #(pkgs.writeTextDir "etc/dbus-1/system.conf" ''
  #  <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN" "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
  #  <busconfig>
  #    <includedir>system.d</includedir>
  #  </busconfig> '')

  #(pkgs.writeTextDir "etc/dbus-1/session.conf" ''
  #  <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN" "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
  #  <busconfig>
  #    <includedir>session.d</includedir>
  #  </busconfig> '')

  (pkgs.writeShellScriptBin "entrypoint" ''
    tail -f /dev/null
    '')
    ]; 
  }; 

  config = {
  Env = ["PATH=/bin/"];
  Cmd = [ "entrypoint" ];
  #Healthcheck = {
  #  Test = [ "CMD-SHELL" "pgrep dbus-daemon > /dev/null || exit 1" ];
  #  Interval = 5 * 1000000000;
  #  Timeout = 10 * 1000000000;
  #  Retries = 10;
  #  };
  };
}
