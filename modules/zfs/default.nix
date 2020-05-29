{ config, lib, pkgs, ... }:

{
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8;
    monthly = 3;
  };
}
