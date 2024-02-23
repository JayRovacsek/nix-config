{ config, lib, ... }: {
  systemd.services.grafana-agent.serviceConfig.SupplementaryGroups =
    lib.mkForce [ "systemd-journal" "clamav" ];

  services.prometheus = {
    enable = true;
    retentionTime = "30d";
    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" "processes" ];
      port = 9100;
      openFirewall = true;
    };
    scrapeConfigs = [
      {
        job_name = "blocky";
        static_configs = [{
          targets = [ "127.0.0.1:4000" ];
          labels = { host = config.networking.hostName; };
        }];
      }
      {
        job_name = "node";
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
  };

  services.grafana-agent = {
    enable = true;

    settings.logs.configs = [{
      name = "logging";
      clients = [{ url = "http://127.0.0.1:3100/loki/api/v1/push"; }];
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
  };
}
