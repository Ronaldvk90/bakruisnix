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

    packages.x86_64-linux = {

      # dbus 
      dbus-x86 =
        import ./dbus.nix {
          pkgs = pkgsX86;
        };

      dbus-arm64 =
        import ./dbus.nix {
          pkgs = pkgsArm64;
        };

      dbus-armv7 =
        import ./dbus.nix {
          pkgs = pkgsArmv7;
        };

      # avahi 
      avahi-x86 =
        import ./avahi.nix {
          pkgs = pkgsX86;
        };

      avahi-arm64 =
        import ./avahi.nix {
          pkgs = pkgsArm64;
        };

      avahi-armv7 =
        import ./avahi.nix {
          pkgs = pkgsArmv7;
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
