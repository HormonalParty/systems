{config, lib, ...}:

with lib;

let
  cfg = config.hormonalparty.monitoring-server;

  monTypes.node_scrape_targets = types.submodule {
    options = {
      targets = mkOption {
        type = types.listOf types.str;
        description = ''
          The targets specified by the target group.
          '';
      };
      labels = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          Labels assigned to all metrics scraped from the targets.
          '';
      };
    };
  };
in
{
  options.hormonalparty.monitoring-server = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable monitoring collection on this host
      '';
    };

    grafanaDomain = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The domain where grafana will be available.
      '';
    };

    openFirewallPorts = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Should the module automatically open ports for grafana?
      '';
    };

    nodeScrapeTargets = mkOption {
      type = types.listOf monTypes.node_scrape_targets;
      default = [];
      description = ''
        The list of hosts that should have their node exporters scraped.
      '';
    };

    scrapeConfigs = mkOption {
      default = [];
      description = ''
        A list of scrape configurations.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf (cfg.grafanaDomain != "") {
      allowedTCPPorts = [ config.services.grafana.port ];
    };
    services = {
      prometheus = {
        enable = true;
        scrapeConfigs = [
          {
            job_name = "node";
            scrape_interval = "10s";
            static_configs = cfg.nodeScrapeTargets;
          }
        ] ++ cfg.scrapeConfigs;
      };

      grafana = mkIf (cfg.grafanaDomain != "") {
        enable = true;
        addr = "0.0.0.0";
        domain = cfg.grafanaDomain;
        rootUrl = "http://${cfg.grafanaDomain}/";

        provision = {
          enable = true;
          datasources = [
            {
              name = "Local Prometheus";
              type = "prometheus";
              url = "http://localhost:9090";
              isDefault = true;
            }
          ];
        };
      };
    };
  };
}
