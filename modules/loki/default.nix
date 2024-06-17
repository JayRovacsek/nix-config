{ config, self, ... }:
let inherit (self.common.networking.services) loki;
in {
  networking.firewall.allowedTCPPorts =
    [ config.services.loki.configuration.server.http_listen_port ];

  services.loki = {
    enable = true;
    configuration = {
      auth_enabled = false;

      analytics.reporting_enabled = false;

      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/tmp/loki";
        replication_factor = 1;

        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };

        storage.filesystem = {
          chunks_directory = "${config.services.loki.dataDir}/chunks";
          rules_directory = "${config.services.loki.dataDir}/rules";
        };
      };

      schema_config.configs = [{
        from = "2020-10-24";
        index = {
          prefix = "index_";
          period = "24h";
        };
        object_store = "filesystem";
        schema = "v12";
        store = "tsdb";
      }];

      server = {
        http_listen_address = "0.0.0.0";
        http_listen_port = loki.port;
      };
    };
  };

  users = {
    groups.${config.services.loki.group} = { inherit (loki.user) gid; };
    users.${config.services.loki.user} = { inherit (loki.user) uid; };
  };

}
