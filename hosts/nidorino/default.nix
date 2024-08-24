{ config, self, ... }:
{
  imports = with self.nixosModules; [
    ./authelia.nix
    agenix
    authelia
    grafana-agent
    microvm-guest
    nix-topology
    nginx
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:09:02";
        macvtap = {
          link = "auth";
          mode = "bridge";
        };
      }
    ];

    mem = 1024;
    vcpu = 2;
  };

  networking.hostName = "nidorino";

  services.nginx.statusPage = true;

  system.stateVersion = "24.05";
}
