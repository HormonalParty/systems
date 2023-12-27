{
  description = "Base system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.lisbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ({ pkgs, ... }: {
            imports = [
              ./sys/lisbon.infra.hormonal.party/configuration.nix
            ];

            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = [
              "nixpkgs=${nixpkgs}"
            ];
          })
          ./modules/default
          ./modules/hardware/amd
          ./modules/remote-build-host
          ./modules/zfs
          ./modules/vpn
          ./modules/prometheus
        ];
      };
    };
  }
