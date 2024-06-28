{ self, ... }: {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" "processes" ];
    inherit (self.common.networking.services.exporters-node) port;
  };
}
