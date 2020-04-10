{ config, lib, pkgs, ... }:

{
  users.users.remote-build-user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLG++puQtyfh0LVX8zu4KOtfgQFnJdbwT3JZZPsevam root@ellipse"
    ];
  };
}
