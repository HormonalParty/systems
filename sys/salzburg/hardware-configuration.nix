{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4ABA-BAFC";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9e5373d2-47e0-4700-adb5-66f0ecaab3c0"; }
    ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
