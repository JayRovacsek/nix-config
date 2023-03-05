{

  services.promtail = {
    enable = true;
    extraFlags = [ "-config.file=/etc/nixos/promtail-config.yml" ];
    configuration = {
      server = {
        http_listen_port = 9080;
        grpc_listen_port = 0;
      };
      positions = { filename = "/tmp/positions.yaml"; };
      clients = [{ url = "https://loki.rovacsek.com/loki/api/v1/push"; }];
      scrape_configs = [{
        job_name = "local";
        static_configs = {
          targets = "localhost";
          labels = {
            job = "varlogs";
            __path__ = "/var/log/*log";
          };
        };
        relabel_configs = [{
          source_labels = [ "__journal__systemd_unit" ];
          target_label = "unit";
        }];
      }];
    };
  };
}
