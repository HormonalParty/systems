{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/36a0ab77-f363-4ce9-8105-fdd85ce2a545";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/dc582454-e81c-477d-bf70-9695a2cc2e35"; }
      { device = "/dev/disk/by-uuid/7dc74649-ef6b-4147-86b8-b8070f84c6da"; }
    ];

  nix.maxJobs = lib.mkDefault 12;
}