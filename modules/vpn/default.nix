{ config, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  networking.firewall.checkReversePath = "loose";
}
