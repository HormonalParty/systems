{ config, lib, pkgs, ... }:

{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.groups.media.members = [ "danielle" "maxine" "plex" ];

  fileSystems."/mnt/media" = {
    device = "/storage/media";
    options = [ "bind" ];
  };
}
