{ config, lib, pkgs, ... }:

let portMap = {
  recipies = 2368;
  quassel = 4242;
  grafana = 3000;
  loki = 3001;
}; in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/hardware/amd
    ../../modules/remote-build-host
    ../../modules/zfs
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = false;
    devices = [
      "/dev/nvme0n1" "/dev/nvme1n1"
    ];
  };

  networking.hostName = "berlin";
  networking.domain = "infra.hormonal.party";
  networking.hostId = "7d25489c";

  networking = {
    firewall = {
      allowedTCPPorts = [ 22 443 80 config.services.quassel.portNumber ];
      enable = true;
    };

    usePredictableInterfaceNames = false;
    enableIPv6 = true;
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "178.63.8.90";
        prefixLength = 26;
      }];
      ipv6.addresses = [{
        address = "2a01:4f8:110:437b::1";
        prefixLength = 64;
      }];
    };
    defaultGateway = "178.63.8.65";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [
      "213.133.98.98" "213.133.99.99" "213.133.100.100"
      "2a01:4f8:0:a0a1::add:1010" "2a01:4f8:0:a102::add:9999"
      "2a01:4f8:0:a111::add:9898"
    ];
  };

  time.timeZone = "UTC";

  system.stateVersion = "20.09";

  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers."recipies-danielle-fyi" = {
    image = "ghost:3.13";
    environment = {
      url = "https://recipes.danielle.fyi";
      WEB_DOMAIN = "https://recipes.danielle.fyi";
    };
    volumes = [
      "/var/lib/recipies-danielle-fyi:/var/lib/ghost/content"
    ];
    ports = [
      "${toString portMap.recipies}:2368"
    ];
  };

  security.acme.acceptTerms = true;

  security.acme.defaults.email = "dani@builds.terrible.systems";

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    commonHttpConfig = ''
      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

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
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    enableReload = true;
  };

  services.nginx.virtualHosts."recipies.danielle.fyi" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString portMap.recipies}/";

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
      proxyPass = "http://localhost:${toString portMap.recipies}/";

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

  services.nginx.virtualHosts."grafana.svc.hormonal.party" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:${toString portMap.grafana}/";

      extraConfig = ''
        proxy_redirect off;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        server_name_in_redirect off;
      '';
    };
  };

  services.quassel = {
    enable = true;
    certificateFile = "/var/lib/quassel/quasselCert.pem";
    requireSSL = true;
    dataDir = "/var/lib/quassel";
    interfaces = [ "0.0.0.0" ];
  };

  services.grafana = {
    enable   = true;
    port     = portMap.grafana;
    domain   = "localhost";
    protocol = "http";
    rootUrl  = "https://grafana.svc.hormonal.party";
    dataDir  = "/var/lib/grafana";

    provision.datasources = [
      {
        name = "loki";
        type = "loki";
        url = "localhost:${toString portMap.loki}";
      }
    ];
  };

  services.loki = {
    enable = true;

    configuration = {
      auth_enabled = false;

      server = {
        http_listen_port = portMap.loki;
      };

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "5m";
        chunk_retain_period = "30s";
      };

      storage_config = {
        boltdb = {
          directory = "/var/lib/loki/index";
        };
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      schema_config = {
        configs = [
          {
            from = "2020-05-15";
            store = "boltdb";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "168h";
            };
          }
        ];
      };

      limits_config = {
        enforce_metric_name = false;
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };
    };
  };
}
