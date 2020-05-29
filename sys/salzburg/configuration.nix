{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/remote-build-host
    ../../modules/hardware/intel
    ../../modules/plex
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

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.nvidiaPersistenced = true;

  system.stateVersion = "20.09";
}
