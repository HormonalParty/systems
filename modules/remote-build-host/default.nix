{ config, lib, pkgs, ... }:

{
  users.users.remote-build-user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLG++puQtyfh0LVX8zu4KOtfgQFnJdbwT3JZZPsevam root@ellipse"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMA2zzxDQEt2Nv9nNa6btvm/2fyVMXFSMyw1259+o0T root@mir"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUSa0uFUgoaes/Z95LoijexaKfU9XeMB8GdQkvojWCj root@chirm"
    ];
  };
}
