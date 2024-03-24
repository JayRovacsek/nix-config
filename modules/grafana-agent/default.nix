{ config, lib, self, ... }:
let inherit (self.common.networking.services) loki prometheus;
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
        scrape_configs = [
          {
            job_name = "clamd";
            static_configs = [{
              targets = [ "localhost" ];
              labels = {
                __path__ = "/var/log/clamd.log";
                host = config.networking.hostName;
                job = "clamd";
              };
            }];
          }
          {
            job_name = "zfs";
            static_configs = [{
              targets = [ "localhost:9273" ];
              labels = {
                host = config.networking.hostName;
                job = "zfs";
              };
            }];
          }
          {
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
          }
        ];
      }];

      metrics = {
        global = {
          remote_write = [{
            url = "${prometheus.protocol}://${prometheus.ipv4}:${
                builtins.toString prometheus.port
              }/${prometheus.write-api}";
          }];
        };

        configs = [{
          name = "prometheus_scrape_configs";
          scrape_configs = [
            {
              job_name = "blocky";
              scheme = "http";

              static_configs = [{
                targets = [ "127.0.0.1:4000" ];
                labels = { host = config.networking.hostName; };
              }];
            }
            {
              job_name = "node";
              scheme = "http";
              static_configs = [{
                targets = [
                  "localhost:${
                    toString config.services.prometheus.exporters.node.port
                  }"
                ];
                labels = { host = config.networking.hostName; };
              }];
            }
          ];
        }];

      };
    };
  };
}
