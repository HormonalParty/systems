{ config, pkgs, ... }:

{
  nix = {
    buildMachines = [
      {
        hostName = "berlin.infra.hormonal.party";
        system = "x86_64-linux";
        maxJobs = 12;
        speedFactor = 2;
        supportedFeatures = [ "nixos-tests" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "lisbon.infra.hormonal.party";
        system = "x86_64-linux";
        maxJobs = 16;
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
