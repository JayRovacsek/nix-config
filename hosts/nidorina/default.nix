{ config, self, ... }: {
  imports = (with self.nixosModules; [
    acme
    agenix
    ddclient
    grafana-agent
    microvm-guest
    nix-topology
    nginx
    time
    timesyncd
  ]) ++ [ ./nginx.nix ];

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:05:03";
      macvtap = {
        link = "reverse-proxy";
        mode = "bridge";
      };
    }];

    mem = 1024;
  };

  networking.hostName = "nidorina";

  system.stateVersion = "24.05";
}
