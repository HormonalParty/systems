{
  description = "Base system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      sintra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({ pkgs, ... }: {
              imports = [
                ./sys/sintra/configuration.nix
              ];

              nix.registry.nixpkgs.flake = nixpkgs;
              nix.nixPath = [
                "nixpkgs=${nixpkgs}"
              ];
            })
            ./modules/default
            ./modules/remote-build-host
            ./modules/nix-cache-host
            ./modules/hardware/amd
            ./modules/hardware/nvidia
            ./modules/plex
            ./modules/zfs
            ./modules/vpn
            ./modules/prometheus
            ./modules/gomodulecache
          ];
      };
      lisbon = nixpkgs.lib.nixosSystem {
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
  };
}
