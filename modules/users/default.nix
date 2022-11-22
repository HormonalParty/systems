{ config, lib, pkgs, ... }:

{
  programs.fish = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  users.users.maxine = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDmex7rvB7BFd9OxQHfgqKogiN69kHvixCzWWEGh5oY maxine@chirm"
    ];
    uid = 1002;
  };

  users.users.danielle = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM3bsRW8tLBO3PmpXPrpE635Zu7qOWgWvDRrTm2QQh8Z danielle@mir"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINx6NhFAcuwyR3ralO+ikopApVQieJtXHieLkQlQN/dn danielle@mimas"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoD598agSpqesPHgLiwBHrNmq/yk1u14yxb7cDTpMge danielle@boson"
    ];
    uid = 1000;
  };

  security.sudo.wheelNeedsPassword = false;
}
