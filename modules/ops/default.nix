{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    tmux
    vim
    wget
    jq
    htop
    dnsutils
    lsof
    telnet
    nmap
    lm_sensors
    smartmontools
    nvme-cli
  ];

  programs.mtr.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
