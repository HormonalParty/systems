{ config, lib, pkgs, ... }:

{
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
}
