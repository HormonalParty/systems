{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    devices = [
      "/dev/nvme0n1" "/dev/nvme1n1"
    ];
  };

  networking.hostName = "lisbon";
  networking.domain = "infra.hormonal.party";
  networking.hostId = "9cd372da";

  networking = {
    firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [ 22 80 443 8000 8001 8002 8003 8080 3000 4242 ];
      enable = true;
    };

    usePredictableInterfaceNames = false;
    enableIPv6 = true;
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "65.108.68.203";
        prefixLength = 26;
      }];
      ipv6.addresses = [{
        address = "2a01:4f9:6b:44da::1";
        prefixLength = 64;
      }];
    };
    defaultGateway = "65.108.68.193";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [
      "185.12.64.1" "185.12.64.2"
      "2a01:4ff:ff00::add:1" "2a01:4ff:ff00::add:2"
    ];
  };

  time.timeZone = "UTC";

  system.stateVersion = "22.05";

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";
  virtualisation.containerd = {
    enable = true;
    settings = {
      plugins."io.containerd.grpc.v1.cri" = {
        containerd.snapshotter = "overlayfs";
      };
    };
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers."recipes-danielle-fyi" = {
    image = "ghost:3.13";
    environment = {
      url = "https://recipes.danielle.fyi";
      WEB_DOMAIN = "https://recipes.danielle.fyi";
    };
    volumes = [
      "/var/lib/recipes-danielle-fyi:/var/lib/ghost/content"
    ];
    ports = [
      "2368:2368"
    ];
  };

  services.quassel = {
    enable = true;
    certificateFile = "/var/lib/quassel/quasselCert.pem";
    requireSSL = true;
    dataDir = "/var/lib/quassel";
    interfaces = [ "0.0.0.0" ];
  };

  security.acme.acceptTerms = true;

  security.acme.defaults.email = "dani@builds.terrible.systems";

  services.nginx = {
    enable = true;

    logError = "stderr debug";

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # Enable XSS protection of the browser.
      # May be unnecessary when CSP is configured properly (see above)
      add_header X-XSS-Protection "1; mode=block";

      # This might create errors
      #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

      proxy_headers_hash_max_size 1024;
      proxy_headers_hash_bucket_size 128;
    '';

    enableReload = true;
  };

  services.nginx.virtualHosts."recipies.danielle.fyi" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:2368/";

      extraConfig = ''
        proxy_redirect off;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    Host      $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        server_name_in_redirect off;
      '';
    };
  };

  services.nginx.virtualHosts."recipes.danielle.fyi" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:2368/";

      extraConfig = ''
        proxy_redirect off;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    Host      $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        server_name_in_redirect off;
      '';
    };
  };

  services.nginx.virtualHosts."git.hormonal.party" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3700";

      extraConfig = ''
        client_max_body_size 512M;
        proxy_set_header Connection $http_connection;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };


  services.gitea = {
    enable = true;
    appName = "Gitea";
    database = {
      type = "sqlite3";
    };
    settings = {
      actions.ENABLED = true;
      service = {
        DISABLE_REGISTRATION = true;
      };
      server = {
        DOMAIN = "git.hormonal.party";
        ROOT_URL = "https://git.hormonal.party/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3700;
      };
    };
  };
}
