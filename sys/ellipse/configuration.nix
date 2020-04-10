{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/hardware/intel
    ../../modules/use-remote-builds
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;

  networking.hostName = "ellipse";
  networking.hostId = "59adcdae";

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;
    monthly = 3;
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 22 ];
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/mnt/media" = {
	  device = "//192.168.178.105/media";
	  fsType = "cifs";
	  options = let
# this line prevents hanging on network split
		  automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,sec=ntlmssp";
	  in ["${automount_opts},credentials=/etc/nixos/secrets-naspw,uid=${toString config.users.users.plex.uid},gid=${toString config.users.groups.plex.gid}"];
  };

  system.stateVersion = "20.03";
}
