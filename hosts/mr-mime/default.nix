{ config, self, ... }:
{
  age.identityPaths = [
    "/agenix/id-ed25519-mr-mime-primary"
  ];

  imports = with self.nixosModules; [
    agenix
    grafana
    grafana-agent
    loki
    microvm-guest
    prometheus
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "mr-mime";

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:12:02";
        macvtap = {
          link = "log";
          mode = "bridge";
        };
      }
    ];

    mem = 4096;

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

  services.grafana.settings.server.root_url = "https://grafana.rovacsek.com";

  system.stateVersion = "24.05";
}
