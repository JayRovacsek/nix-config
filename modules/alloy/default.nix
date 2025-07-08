{
  config,
  lib,
  self,
  ...
}:
let
  inherit (self.common.config.services) loki prometheus telegraf;

  blocky-enabled = config.services.blocky.enable;
  clamav-enabled = config.services.clamav.daemon.enable;
  hydra-enabled = config.services.hydra.enable;
  mysql-enabled = config.services.prometheus.exporters.mysqld.enable;
  nextcloud-enabled = config.services.prometheus.exporters.redis.enable;
  nginx-enabled = config.services.nginx.enable;
  node-enabled = config.services.prometheus.exporters.node.enable;
  redis-enabled = config.services.prometheus.exporters.redis.enable;
  # TODO: change this so it checks for zfs also.
  telegraf-enabled = config.services.telegraf.enable;

  blocky-prom-config = {
    job_name = "blocky";
    scheme = "http";

    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [
          "127.0.0.1:${builtins.toString config.services.blocky.settings.ports.http}"
        ];
      }
    ];
  };

  clamav-promtail-config = {
    job_name = "clamd";
    static_configs = [
      {
        labels = {
          __path__ = config.services.clamav.daemon.settings.LogFile;
          host = config.networking.hostName;
          job = "clamd";
        };
        targets = [ "127.0.0.1" ];
      }
    ];
  };

  hydra-prom-config = {
    job_name = "hydra";
    metrics_path = "/prometheus";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;

        targets = [ "127.0.0.1:${builtins.toString config.services.hydra.port}" ];
      }
    ];
  };

  hydra-notify-prom-config = {
    job_name = "hydra_notify";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [ "127.0.0.1:${builtins.toString config.services.hydra.port}" ];
      }
    ];
  };

  mysql-prom-config = {
    job_name = "mysql";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [
          "127.0.0.1:${builtins.toString config.services.prometheus.exporters.mysqld.port}"
        ];
      }
    ];
  };

  nextcloud-prom-config = {
    job_name = "nextcloud";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [
          "127.0.0.1:${builtins.toString config.services.prometheus.exporters.nextcloud.port}"
        ];
      }
    ];
  };

  nginx-prom-config = {
    job_name = "nginx";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [
          "127.0.0.1:${builtins.toString config.services.prometheus.exporters.nginx.port}"
        ];
      }
    ];
  };

  node-prom-config = {
    job_name = "node";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [
          "127.0.0.1:${builtins.toString config.services.prometheus.exporters.node.port}"
        ];
      }
    ];
  };

  redis-prom-config = {
    job_name = "redis";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [
          "127.0.0.1:${builtins.toString config.services.prometheus.exporters.redis.port}"
        ];
      }
    ];
  };

  zfs-telegraf-config = {
    job_name = "zfs";
    scheme = "http";
    static_configs = [
      {
        labels.host = config.networking.hostName;
        targets = [ "127.0.0.1:${builtins.toString telegraf.output.prometheus.port}" ];
      }
    ];
  };
in
{
  systemd.services.alloy.serviceConfig.SupplementaryGroups = lib.mkForce (
    [ "systemd-journal" ] ++ (lib.optional clamav-enabled "clamav")
  );

  services.alloy = {
    enable = true;

    extraFlags = [
      "--config.format=static"
    ];

    configPath = builtins.toFile "settings.json" (
      builtins.toJSON {
        integrations.node_exporter.enabled = true;

        logs.configs = [
          {
            name = "logging";
            clients = [
              {
                url = "${loki.protocol}://${loki.ipv4}:${builtins.toString loki.port}/${loki.push-api}";
              }
            ];
            positions.filename = "\${STATE_DIRECTORY}/loki_positions.yaml";
            scrape_configs = [
              {
                job_name = "journal";
                journal = {
                  max_age = "12h";
                  labels = {
                    host = config.networking.hostName;
                    job = "systemd-journal";
                  };
                };
                relabel_configs =
                  lib.mapAttrsToList
                    (source: target: {
                      source_labels = lib.singleton source;
                      target_label = target;
                    })
                    {
                      "__journal__systemd_unit" = "systemd_unit";
                      "__journal__systemd_user_unit" = "systemd_user_unit";
                    };
              }
            ] ++ (lib.optional clamav-enabled clamav-promtail-config);
          }
        ];

        metrics = {
          global = {
            remote_write = [
              {
                url = "${prometheus.protocol}://${prometheus.ipv4}:${builtins.toString prometheus.port}/${prometheus.write-api}";
              }
            ];
            scrape_interval = "15s";
            scrape_timeout = "5s";
          };

          configs = [
            {
              name = "prometheus_scrape_configs";
              scrape_configs =
                (lib.optional blocky-enabled blocky-prom-config)
                ++ (lib.optionals hydra-enabled [
                  hydra-prom-config
                  hydra-notify-prom-config
                ])
                ++ (lib.optional mysql-enabled mysql-prom-config)
                ++ (lib.optional nextcloud-enabled nextcloud-prom-config)
                ++ (lib.optional nginx-enabled nginx-prom-config)
                ++ (lib.optional node-enabled node-prom-config)
                ++ (lib.optional redis-enabled redis-prom-config)
                ++ (lib.optional telegraf-enabled zfs-telegraf-config);
            }
          ];
        };
      }
    );
  };
}
