_: {
  services = {
    influxdb = { enable = true; };
    telegraf = {
      enable = true;
      extraConfig = {
        inputs = { zfs = { poolMetrics = true; }; };
        outputs = {
          influxdb = {
            database = "telegraf";
            urls = [ "http://localhost:8086" ];
          };
        };

        outputs.prometheus_client.listen = ":9273";
      };
    };
  };
}
