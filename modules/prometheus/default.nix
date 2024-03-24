{ self, ... }:
let inherit (self.common.networking.services) exporters-node prometheus;
in {
  services.prometheus = {
    enable = true;

    exporters.node = {
      inherit (exporters-node) port;
      enable = true;
      enabledCollectors = [ "systemd" "processes" ];
      openFirewall = true;
    };

    extraFlags = [ "--web.enable-remote-write-receiver" ];

    inherit (prometheus) port;

    retentionTime = "30d";
  };
}
