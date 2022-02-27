{ config, lib, pkgs, ... }:

{
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/be901273-bc87-4520-ab79-e87aad3d0030";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/2d67e431-99a4-4b4e-ab31-ca98cb146ad8";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1f5ea092-7a9a-404f-a234-1fa82c10f37a"; }
      { device = "/dev/disk/by-uuid/f2e0778e-88c4-4624-bcdf-173988f25980"; }
    ];

  nix.settings.max-jobs = lib.mkDefault 16;
}
