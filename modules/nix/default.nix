{ config, lib, pkgs, ... }:

{
  nix = {
    nixPath = [
      "nixos-config=/run/current-system/systems/sys/${config.networking.hostName}.nix"
      "/var/run/current-system/systems"
    ];
    useSandbox = true;
    autoOptimiseStore = true;
    trustedUsers = [ "@wheel" ];

    binaryCaches = [
      "https://nixcache.infra.terrible.systems/"
    ];
    trustedBinaryCaches = [
      "https://nixcache.infra.terrible.systems/"
    ];
    binaryCachePublicKeys = [
      "nixcache.infra.terrible.systems:BXjTXh35v6pyOf6kjkhd2T2Z1hXrCa4j/64HCwbZ5Mw="
    ];
  };

  system.extraSystemBuilderCmds = ''
    ln -s ${lib.cleanSource ../..} $out/systems
  '';
}
