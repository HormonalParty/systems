{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  environment.systemPackages = with pkgs; [
    git
    tmux
    vim
    wget
    jq
    htop
    dnsutils
    lsof
    inetutils
    nmap
    lm_sensors
    smartmontools
    nvme-cli
  ];

  programs.mtr.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
