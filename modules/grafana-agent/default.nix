{ config, lib, self, ... }:
let
  inherit (self.common.networking.services) loki prometheus;

  blocky-enabled = config.services.blocky.enable;
  clamav-enabled = config.services.clamav.daemon.enable;
  node-enabled = config.services.prometheus.exporters.node.enable;

  blocky-prom-config = {
    job_name = "blocky";
    scheme = "http";

    static_configs = [{
      labels.host = config.networking.hostName;
      targets = [
        "127.0.0.1:${
          builtins.toString config.services.blocky.settings.ports.http
        }"
      ];
    }];
  };

  clamav-promtail-config = {
    job_name = "clamd";
    static_configs = [{
      labels = {
        __path__ = config.services.clamav.daemon.settings.LogFile;
        host = config.networking.hostName;
        job = "clamd";
      };
      targets = [ "127.0.0.1" ];
    }];
  };

  node-prom-config = {
    job_name = "node";
    scheme = "http";
    static_configs = [{
      labels.host = config.networking.hostName;
      targets = [
        "127.0.0.1:${
          builtins.toString config.services.prometheus.exporters.node.port
        }"
      ];
    }];
  };
in {
  systemd.services.grafana-agent.serviceConfig.SupplementaryGroups =
    lib.mkForce [ "systemd-journal" "clamav" ];

  services.grafana-agent = {
    enable = true;

    settings = {
      logs.configs = [{
        name = "logging";
        clients = [{
          url = "${loki.protocol}://${loki.ipv4}:${
              builtins.toString loki.port
            }/${loki.push-api}";
        }];
        positions.filename = "\${STATE_DIRECTORY}/loki_positions.yaml";
        scrape_configs = [{
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              host = config.networking.hostName;
              job = "systemd-journal";
            };
          };
          relabel_configs = lib.mapAttrsToList (source: target: {
            source_labels = lib.singleton source;
            target_label = target;
          }) {
            "__journal__systemd_unit" = "systemd_unit";
            "__journal__systemd_user_unit" = "systemd_user_unit";
          };
        }] ++ (lib.optional clamav-enabled clamav-promtail-config);
      }];

      metrics = {
        global = {
          evaluation_interval = "15s";
          remote_write = [{
            url = "${prometheus.protocol}://${prometheus.ipv4}:${
                builtins.toString prometheus.port
              }/${prometheus.write-api}";
          }];
          scrape_interval = "15s";
          scrape_timeout = "5s";
        };

        configs = [{
          name = "prometheus_scrape_configs";
          scrape_configs = (lib.optional blocky-enabled blocky-prom-config)
            ++ (lib.optional node-enabled node-prom-config);
        }];

      };
    };
  };
}
