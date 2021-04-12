# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "igb" "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "root/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "root/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/79D4-F878";
      fsType = "vfat";
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/mapper/docker";
      fsType = "ext4";
    };

  #fileSystems."/storage/backups" =
  #  { device = "storagePool/backups";
  #    fsType = "zfs";
  #  };

  #fileSystems."/storage/media" =
  #  { device = "storagePool/media";
  #    fsType = "zfs";
  #  };

  #fileSystems."/storage/data" =
  #  { device = "storagePool/data";
  #    fsType = "zfs";
  #  };

  #fileSystems."/storage/home/danielle" =
  #  { device = "storagePool/home/danielle";
  #    fsType = "zfs";
  #  };

  #fileSystems."/storage/home/maxine" =
  #  { device = "storagePool/home/maxine";
  #    fsType = "zfs";
  #  };

  boot.zfs.extraPools = [ "storagePool" ];

  swapDevices =
    [ { device = "/dev/disk/by-uuid/7a85e95c-0227-4670-80e6-e80b1afab498"; } ];

}