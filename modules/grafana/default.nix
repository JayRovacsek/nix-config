{ config, self, ... }:
let
  inherit (self.common.config.services) grafana loki prometheus;
in
{
  networking.firewall.allowedTCPPorts = [
    config.services.grafana.settings.server.http_port
  ];

  services.grafana = {
    enable = true;

    provision = {
      enable = true;

      dashboards.settings.providers = [
        {
          name = "Blocky";
          options.path = ./dashboards/blocky.json;
        }
        {
          name = "Node Exporter";
          options.path = ./dashboards/node-exporter.json;
        }
        {
          name = "ZFS";
          options.path = ./dashboards/zfs.json;
        }
      ];

      datasources.settings.datasources = [
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "${loki.protocol}://${loki.ipv4}:${builtins.toString loki.port}";
        }
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "${prometheus.protocol}://${prometheus.ipv4}:${builtins.toString prometheus.port}";
        }
      ];
    };

    settings = {
      "auth.anonymous".enabled = false;
      alerting.enabled = false;
      analytics.reporting_enabled = false;
      panels.disable_sanitize_html = true;

      security = {
        # TODO: change before deploy
        admin_password = "test";
        admin_user = "admin";
      };

      server = {
        # domain = "grafana.rovacsek.com";
        # root_url = "https://${name}.${domain}/";
        enable_gzip = true;
        # TODO: change prior to deploy
        enforce_domain = false;
        # TODO: change prior to deploy
        http_addr = "0.0.0.0";

        inherit (grafana) protocol;
        http_port = grafana.port;
      };

      users.auto_assign_org_role = "Editor";
      unified_alerting.enabled = true;
    };
  };
}
