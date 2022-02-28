{ config, ... }:

{
  services.prometheus = {
    enable = true;
    retentionTime = "1d";

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };

    scrapeConfigs = [
      {
        job_name = config.networking.hostName;
        static_configs = [{
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
          ];
        }];
      }
    ];

    remoteWrite = [
      {
        url = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push";
        basic_auth = {
          username = "346362";
          password_file = "/etc/nixos/secrets/prometheus";
        };
      }
    ];
  };
}
