{ config, self, ... }: {
  imports = with self.nixosModules; [
    agenix
    grafana
    loki
    microvm-guest
    prometheus
    time
    timesyncd
  ];

  networking.hostName = "mr-mime";

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:12:02";
      macvtap = {
        link = "log";
        mode = "bridge";
      };
    }];

    mem = 2048;

    shares = [
      {
        # On the host
        source = "/srv/logs/loki";
        # In the MicroVM
        mountPoint = config.services.loki.dataDir;
        tag = "loki";
        proto = "virtiofs";
      }
      {
        # On the host
        source = "/srv/logs/prometheus";
        # In the MicroVM
        mountPoint = "/var/lib/${config.services.prometheus.stateDir}";
        tag = "prometheus";
        proto = "virtiofs";
      }
    ];
  };

  system.stateVersion = "24.05";
}
