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
    ../../modules/vpn
    ../../modules/prometheus
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sintra";
  networking.hostId = "c22782e7";

  networking.networkmanager.enable = true;

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
      hosts allow = 192.168.2.0/24 localhost
      hosts deny = 0.0.0.0/0
      vfs objects = catia fruit streams_xattr
      fruit:appl = yes
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
        "valid users" = "danielle";
      };
      maxine = {
        path = "/storage/home/maxine";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0600";
        "directory mask" = "0700";
        "valid users" = "maxine";
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      137 138 # samba
     ];
    allowedTCPPorts = [
      2049 # nfs
      22 # ssh
      445 139 # samba
      443
      80
    ];
    enable = true;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "dani@builds.terrible.systems";

  services.nginx.enable = true;

  services.nginx.virtualHosts."nixcache.infra.terrible.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:${toString config.services.nix-serve.port};
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    '';
  };

  services.nginx.virtualHosts."plex.terrible.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
    };
  };

  time.timeZone = "UTC";

  system.stateVersion = "21.05";
}
