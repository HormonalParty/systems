{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/hardware/intel
    ../../modules/use-remote-builds
    ../../modules/zfs
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;

  networking.hostName = "ellipse";
  networking.hostId = "59adcdae";

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "20.03";
}
