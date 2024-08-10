{ config, self, ... }:
let
  inherit (self.common.networking.services) exporters-node prometheus;
in
{
  networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

  services.prometheus = {
    enable = true;

    exporters.node = {
      inherit (exporters-node) port;
      enable = true;
      enabledCollectors = [
        "systemd"
        "processes"
      ];
      openFirewall = true;
    };

    extraFlags = [ "--web.enable-remote-write-receiver" ];

    inherit (prometheus) port;

    retentionTime = "30d";
  };
}
