{ config, lib, pkgs, ... }:

{
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  users.groups.media.members = [ "danielle" "maxine" "plex" ];
}
