{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;

  networking.hostName = "sintra";
  networking.hostId = "c22782e7";

  networking.useNetworkd = true;

  # initrd SSH
  networking.interfaces.enp8s0.useDHCP = true;
  boot.initrd.systemd.network.enable = true;
  boot.initrd.systemd.users.root.shell = "/bin/cryptsetup-askpass";
  boot.initrd.network = {
    #enable = true;

    #shell = "/bin/cryptsetup-askpass";
    #postCommands = ''
    #  echo 'systemd-tty-ask-password-agent' >> /root/.profile
    #'';

    ssh = {
      enable = true;
      #shell = "/bin/cryptsetup-askpass";
      port = 2222; # differentiate from real SSH
      authorizedKeys = (config.users.users.maxine.openssh.authorizedKeys.keys ++ config.users.users.danielle.openssh.authorizedKeys.keys);
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };
  };

  services.resolved.enable = true;

  boot.initrd.luks.devices = {
    zfsRootPool = {
      # nvme0n1p1
      device = "/dev/disk/by-uuid/a53d31be-e3db-4088-9860-e22b884b20d4";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    docker = {
      # nvme0n1p2
      device = "/dev/disk/by-uuid/3e31163c-1810-4d1a-bc84-cff50300920b";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    swap = {
      # nvme0n1p3
      device = "/dev/disk/by-uuid/717d41c2-06c0-44d5-b5e1-e69725ba77ad";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };

    zfsStorage1 = {
      # Exos X18 18TB
      device = "/dev/disk/by-uuid/a68d6ccc-0765-4aa7-92fd-d23331e4f3cb";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage2 = {
      # Exos X18 18TB
      device = "/dev/disk/by-uuid/73360e33-7234-493c-8438-cf5940d469c6";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage3 = {
      # Exos X18 18TB
      device = "/dev/disk/by-uuid/aa655c46-7435-4b5c-a7ca-a344961b6d4d";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage4 = {
      # Exos X18 18TB
      device = "/dev/disk/by-uuid/0062886f-0d1e-47a8-ac1d-2ba36ea0d401";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage5 = {
      # Exos X20 20TB
      device = "/dev/disk/by-uuid/3c6d88db-04b4-477f-a3a8-d197789d7c92";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage6 = {
      # Exos X20 20TB
      device = "/dev/disk/by-uuid/2ef8a68b-a914-4472-8448-c5fd9a8dd76c";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage7 = {
      # Exos X20 20TB
      device = "/dev/disk/by-uuid/045706b9-4cb7-4bca-85ab-e8070bf6bf7d";
      keyFile = "/dev/disk/by-id/usb-SanDisk_Ultra_USB_3.0_05013b3605c960c2dcc4e15d2521bab31346ebcceb4b9748f07ba78ddeb419906f20000000000000000000001a805476009c0d1091558107cba73be6-0:0";
      keyFileSize = 4096;
    };
    zfsStorage8 = {
      # Exos X20 20TB
      device = "/dev/disk/by-uuid/95099d33-7f73-4ba7-af5b-efbb238b80c2";
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
      hosts allow = 192.168.2.0/23 100.64.0.0/10 localhost
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
        "veto files" = "/._.DS_Store/.DS_Store/";
        "delete veto files" = "yes";
      };
      photoprism = {
        path = "/storage/photoprism";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0664";
        "directory mask" = "0775";
        "veto files" = "/._.DS_Store/.DS_Store/";
        "delete veto files" = "yes";
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
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [
      137
      138 # samba
    ];
    allowedTCPPorts = [
      2049 # nfs
      22 # ssh
      445
      139 # samba
      443
      80
      32400
    ];
    enable = true;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "dani@builds.terrible.systems";

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.nginx.virtualHosts."nixcache.infra.terrible.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:9003";
  };

  services.nginx.virtualHosts."plex.home.arpa" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."plex.terrible.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."plex.hormonal.party" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."goproxy.tailnet.hormonal.party" = {
    enableACME = false;
    forceSSL = false;
    locations."/".proxyPass = "http://127.0.0.1:9000";
  };

  services.restic.backups."danielle-home" = {
    repository = "b2:restic-danielle-home";

    paths = [
      "/storage/home/danielle/"
      "/home/danielle/"
    ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 6"
      "--keep-monthly 12"
      "--keep-yearly 1"
    ];

    passwordFile = "/etc/secrets/restic/danielle-home";
    environmentFile = "/etc/secrets/restic/danielle-home-env";

    initialize = true;

    timerConfig = {
      OnCalendar = "03:00";
      RandomizedDelaySec = "1h";
    };
  };

  services.restic.backups."maxine-home" = {
    repository = "b2:restic-sintra-maxine-home";

    paths = [
      "/storage/home/maxine/"
    ];
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];

    passwordFile = "/etc/secrets/restic/maxine-home";
    environmentFile = "/etc/secrets/restic/maxine-home-env";

    initialize = true;

    timerConfig = {
      OnCalendar = "03:00";
      RandomizedDelaySec = "1h";
    };
  };

  services.consul = {
    enable = true;
    webUi = true;
    interface = {
      advertise = "tailscale0";
      bind = "tailscale0";
    };
  };

  services.nomad = {
    enable = true;

    settings = {
      bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}";
      datacenter = "eu-ber-1";
      server = {
        enabled = true;
        # We only run the control plane on Sintra.
        bootstrap_expect = 1;
      };
      client = {
        enabled = true;
      };
      consul = {
        # Consul runs locally, but only listens on tailscale
        address = "{{ GetInterfaceIP \"tailscale0\" }}:8500";
      };
    };
  };

  users.users.photoprism = {
    description = "Photoprism user";
    group = "photoprism";
    isSystemUser = true;
  };

  users.groups.photoprism = { };
  systemd.services.photoprism.serviceConfig.DynamicUser = lib.mkForce false;

  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/storage/photoprism/originals";
    storagePath = "/storage/photoprism/storage";
    importPath = "/storage/photoprism/import";
    address = "100.119.159.53";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_ADMIN_PASSWORD = "admin123";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "http://sintra.brumby-duck.ts.net:2342";
      PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
    };
  };

  services.mysql = {
    enable = true;
    dataDir = "/storage/photoprism/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [{
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    }];
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" "--advertise-exit-nodes" ];
  };

  power.ups = {
    enable = true;
    ups."eaton" = {
      driver = "usbhid-ups";
      port = "auto";
    };
    users.upsmon = {
      passwordFile = "/etc/nixos/secrets/upsmon";
      upsmon = "master";
    };
    upsmon.monitor."eaton" = {
      powerValue = 1;
      user = "upsmon";
    };
  };

  time.timeZone = "UTC";

  system.stateVersion = "21.05";
}
