{ config, pkgs, ... }:

{
  nix = {
    buildMachines = [
      {
        hostName = "salzburg.local";
        system = "x86_64-linux";
        maxJobs = 8;
        speedFactor = 3;
        supportedFeatures = [ "benchmark" "big-parallel" "nixos-tests" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "berlin.infra.hormonal.party";
        system = "x86_64-linux";
        maxJobs = 12;
        speedFactor = 2;
        supportedFeatures = [ "nixos-tests" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
    ];

    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}

