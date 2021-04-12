{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/remote-build-host
    ../../modules/nix-cache-host
    ../../modules/hardware/amd
    ../../modules/hardware/nvidia
    ../../modules/plex
    ../../modules/zfs
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sintra";
  networking.hostId = "c22782e7";

  networking.networkmanager.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # initrd SSH
  networking.interfaces.enp8s0.useDHCP = true;
  boot.initrd.network = {
    enable = true;

    postCommands = ''
      echo 'cryptsetup-askpass' >> /root/.profile
    '';

    ssh = {
      enable = true;
      port = 2222; # differentiate from real SSH
      authorizedKeys = (config.users.users.maxine.openssh.authorizedKeys.keys ++ config.users.users.danielle.openssh.authorizedKeys.keys);
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };
  };

  boot.initrd.luks.devices = {
    zfsRootPool = { # nvme0n1p1
      device = "/dev/disk/by-uuid/a53d31be-e3db-4088-9860-e22b884b20d4";
      fallbackToPassword = true;
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    docker = { # nvme0n1p2
      device = "/dev/disk/by-uuid/3e31163c-1810-4d1a-bc84-cff50300920b";
      fallbackToPassword = true;
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    swap = { # nvme0n1p3
      device = "/dev/disk/by-uuid/717d41c2-06c0-44d5-b5e1-e69725ba77ad";
      fallbackToPassword = true;
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };

    zfsStorage1 = { # Exos X18 18TB
      device = "/dev/disk/by-uuid/a68d6ccc-0765-4aa7-92fd-d23331e4f3cb";
      fallbackToPassword = true;
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage2 = { # Exos X18 18TB
      device = "/dev/disk/by-uuid/73360e33-7234-493c-8438-cf5940d469c6";
      fallbackToPassword = true;
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
  };

  services.nfs.server.enable = true;
  services.samba = {
    package = pkgs.samba4.override {
      enableLDAP = true;
      enablePrinting = true;
      enableMDNS = true;
      enableDomainController = true;
      enableRegedit = true;
    };
    enable = true;
    securityType = "user";
    extraConfig = ''
      hosts allow = 192.168.178.0/24 localhost
      hosts deny = 0.0.0.0/0
    '';
    shares = {
      media = {
        path = "/storage/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
      };
      danielle = {
        path = "/storage/home/danielle";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0600";
        "directory mask" = "0700";
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      53 # dns
      137 138 # samba
     ];
    allowedTCPPorts = [
      2049 # nfs
      22 # SSH
      445 139 # samba
      51826 # Plex
      6443 # k3s
      53 # dns
      80 443 # k3s ingress
      8123 # home assistant
      30001 # athens (go module proxy)
    ];
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    storageDriver = "overlay2";

    autoPrune = {
      enable = true;
    };
  };

  services.k3s = {
    enable = true;
    docker = true;
  };

  time.timeZone = "UTC";

  system.stateVersion = "21.05";
}
