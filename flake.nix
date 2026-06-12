{
  description = "Bakruis Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
  let

    # x86_64
    pkgsX86 = import nixpkgs {
      system = "x86_64-linux";
    };

    # ARM64
    pkgsArm64 = import nixpkgs {
      system = "x86_64-linux";

      crossSystem = {
        config = "aarch64-unknown-linux-gnu";
      };
    };

    # ARMv7
    pkgsArmv7 = import nixpkgs {
      system = "x86_64-linux";

      crossSystem = {
        config = "armv7l-unknown-linux-gnueabihf";
      };
    };

  in {

  compose = pkgsX86.writeText "docker-compose.yml" ''
  services:
    dbus:
      env_file: ".env"
      image: ronaldvk90/dbus:latest
      build: dbus/.
      restart: unless-stopped
      volumes:
        - dbussocket:/var/run/dbus/
        - ./dbus/system_services/:/usr/share/dbus-1/system.d/
        - ./dbus/session_services/:/usr/share/dbus-1/session.d/
      networks:
        bakruislan:
          ipv4_address: 172.31.0.2
      security_opt:
        - label=disable

    avahi:
      depends_on:
        dbus:
          condition: service_healthy
      env_file: ".env"
      image: ronaldvk90/avahi:latest
      build: avahi/.
      restart: unless-stopped
      volumes:
        - dbussocket:/var/run/dbus/
      network_mode: host
      security_opt:
        - label=disable

    pulseaudio:
      hostname: pulseaudio
      depends_on:
        dbus:
          condition: service_healthy
      env_file: .env
      image: ronaldvk90/pulseaudio:latest
      build: pulseaudio/.
      restart: unless-stopped
      volumes:
        - dbussocket:/var/run/dbus/
        - ./pulseaudio/default.pa.d/:/etc/pulse/default.pa.d/
        - /run/udev:/run/udev:ro
      devices:
        - "/dev/snd"
      ports:
        - "4713:4713"
      networks:
        bakruislan:
          ipv4_address: 172.31.0.3
      security_opt:
        - label=disable

    bluetooth:
      depends_on:
        pulseaudio:
          condition: service_healthy
      env_file: ".env"
      image: ronaldvk90/bluetooth:latest
      build: bluetooth/.
      restart: unless-stopped
      volumes:
        - dbussocket:/var/run/dbus/
        - btdevices:/var/lib/bluetooth
      cap_add:
        - NET_ADMIN
        - SYS_ADMIN
      network_mode: host
      security_opt:
        - label=disable

    shairport-sync:
      depends_on:
        pulseaudio:
          condition: service_healthy
      env_file: .env
      image: ronaldvk90/shairport-sync:latest
      restart: unless-stopped
      network_mode: "host"
      volumes:
        - dbussocket:/var/run/dbus/
      logging:
        options:
          max-size: "200k"
          max-file: "10"
      security_opt:
        - label=disable

    spotify:
      depends_on:
        pulseaudio:
          condition: service_healthy
      env_file: .env
      build: spotify/.
      image: ronaldvk90/spotify:latest
      restart: unless-stopped
      network_mode: "host"
      volumes:
        - dbussocket:/var/run/dbus/
      security_opt:
        - label=disable

  volumes:
    btdevices:
    dbussocket:

  networks:
    bakruislan:
      driver: bridge
      ipam:
        config:
          - subnet: 172.31.0.0/24
  '';

    packages.x86_64-linux = {

      # dbus 
      dbus-x86 =
        import ./dbus.nix {
          pkgs = pkgsX86;
          arch = "x86_64";
        };

      dbus-arm64 =
        import ./dbus.nix {
          pkgs = pkgsArm64;
 	  arch = "aarch64";
        };

      dbus-armv7 =
        import ./dbus.nix {
          pkgs = pkgsArmv7;
          arch = "armv7";
        };

      # avahi 
      avahi-x86 =
        import ./avahi.nix {
          pkgs = pkgsX86;
          arch = "x86_64";
        };

      avahi-arm64 =
        import ./avahi.nix {
          pkgs = pkgsArm64;
          arch = "aarch64";
        };

      avahi-armv7 =
        import ./avahi.nix {
          pkgs = pkgsArmv7;
          arch = "armv7";
        };
      
      # shairport-sync
      shairport-sync-x86 =
        import ./shairport-sync.nix {
          pkgs = pkgsX86;
        };

      shairport-sync-arm64 =
        import ./shairport-sync.nix {
          pkgs = pkgsArm64;
        };

      shairport-sync-armv7 =
        import ./shairport-sync.nix {
          pkgs = pkgsArmv7;
        };
    };
  };
}
