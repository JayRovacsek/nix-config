{ self, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
      "processes"
    ];
    inherit (self.common.config.services.exporters-node) port;
  };
}
