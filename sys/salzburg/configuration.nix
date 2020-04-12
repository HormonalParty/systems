{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/remote-build-host
    ../../modules/hardware/intel
    ../../modules/monitoring/server
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "salzburg";
  networking.hostId = "b4e2ebfc";

  networking.networkmanager.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    enable = true;
  };

  time.timeZone = "UTC";

  services.zfs.autoScrub.enable = true;

  hormonalparty.monitoring-server = {
    enable = true;
    grafanaDomain = "salzburg.fritz.box:3000";
    nodeScrapeTargets = [
    {
      targets = [
        "mrow.fritz.box:9100"
      ];
      labels = {
        alias = "home.terrible.systems";
      };
    }
    {
      targets = [
        "ellipse.fritz.box:9100"
      ];
      labels = {
        alias = "plex.terrible.systems";
      };
    }
    ];
  };

  system.stateVersion = "20.09";
}
