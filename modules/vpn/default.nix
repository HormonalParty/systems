{ config, pkgs, ... }:

{
  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  networking.firewall.checkReversePath = "loose";
}
