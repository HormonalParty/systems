{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/remote-build-host
    ../../modules/hardware/intel
    ../../modules/plex
    ../../modules/zfs
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "salzburg";
  networking.hostId = "b4e2ebfc";

  networking.networkmanager.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 51826 ];
    enable = true;
  };

  time.timeZone = "UTC";

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers."homebridge" = {
    image = "oznu/homebridge";

    environment = {
      PUID = "1000";
      PGID = "1000";
      HOMEBRIDGE_CONFIG_UI = "0";
    };

    extraOptions = [ "--network=host" ];

    volumes = [
      "/var/lib/homebridge:/homebridge"
    ];

    ports = [
      "51826:51826"
    ];
  };

  system.stateVersion = "20.09";
}
