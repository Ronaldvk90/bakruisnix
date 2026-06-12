{ pkgs, arch }:

######## DBUS container ##########
pkgs.dockerTools.buildImage {
  name = "ronaldvk90/dbusnix";
  tag = arch;
  copyToRoot = pkgs.buildEnv {
    ignoreCollisions = true;
    name = "rootfs";
    pathsToLink = ["/bin"
                              "/etc"
                             ];

  paths = with pkgs; [
    (pkgs.dbus.overrideAttrs (old: {
    postInstall = ''
    rm -rf $out/etc/dbus-1
  ''; }))
  procps

  (pkgs.writeTextDir "etc/dbus-1/system.conf" ''
    <!DOCTYPE  busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN" http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>
      <includedir>system.d</includedir>
    </busconfig> '')

  (pkgs.writeTextDir "etc/dbus-1/session.conf" ''
    <!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN" "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>
      <includedir>session.d</includedir>
    </busconfig> '')

  (pkgs.writeShellScriptBin "entrypoint" ''
      dbus-daemon --session –fork
      dbus-daemon --system –nofork
    '')
    ]; 
  }; 

  config = {
  Env = ["PATH=/bin/"];
  Cmd = [ "entrypoint" ];
  Healthcheck = {
    Test = [ "CMD-SHELL" "pgrep dbus-daemon > /dev/null || exit 1" ];
    Interval = 5 * 1000000000;
    Timeout = 10 * 1000000000;
    Retries = 10;
    };
  };
}
