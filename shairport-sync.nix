{ pkgs, arch }:

let
shairport = pkgs.stdenv.mkDerivation {
  pname = "shairport-sync-roon";
  version = "5.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "mikebrady";
    repo = "shairport-sync";
    rev = "5.0.4";
    hash = "sha256-7/QB0lvpjZnGXo4vjKSYogjhi66S/QRRpypsqEMLGj0=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
    libplist
    xxd
  ];

  buildInputs = with pkgs; [
    openssl
    avahi
    libpulseaudio
    nqptp
    popt
    libconfig
    soxr
    alsa-lib
    libsndfile
    glib
    mosquitto
    libplist
    xxd
    libsodium
    libgcrypt
    libuuid
    ffmpeg-headless
  ];

  configureFlags = [
#  "--sysconfdir=/etc"
  "--with-alsa"
  "--with-pulseaudio"
  "--with-soxr"
  "--with-avahi"
  "--with-ssl=openssl"
  "--with-airplay-2"
#  "--with-metadata"
#  "--with-dummy"
#  "--with-pipe"
#  "--with-dbus-interface"
#  "--with-stdout"
#  "--with-mpris-interface"
#  "--with-mqtt-client"
#  "--with-apple-alac"
#  "--with-convolution"
#  "--with-pw"
  ];
};
in

#let
#  shairportConfig = pkgs.runCommand "shairport-config" {} ''
#    mkdir -p $out/etc
#
#    cp ${./shairport-sync/shairport-sync.conf} $out/etc/shairport-sync.conf
#  '';
#in

######## Shairport-sync container ##########
pkgs.dockerTools.buildImage {
  name = "ronaldvk90/shairport-syncnix";
  tag = arch;
  copyToRoot = pkgs.buildEnv {
    ignoreCollisions = true;
    name = "rootfs";
    pathsToLink = ["/bin"
                   "/etc"
                  ];

  paths = with pkgs; [
  shairport
  procps
  coreutils
  gnused
  nqptp
  bash
  vim

  (pkgs.writeShellScriptBin "entrypoint" ''
    echo "creating /tmp"
    mkdir /tmp
    chmod 777 /tmp

    echo "Starting nqptp"
    nqptp&


    echo "Starting shairport-sync"
    # pass all commandline options to shairport-sync
    shairport-sync --name=$NAME --output=pulseaudio 
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
