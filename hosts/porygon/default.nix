{ config, self, ... }:
{
  environment.noXlibs = false;

  imports = with self.nixosModules; [
    agenix
    grafana-agent
    microvm-guest
    nix-topology
    palworld
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:11:02";
        macvtap = {
          link = "game";
          mode = "bridge";
        };
      }
    ];

    mem = 8096;
    vcpu = 4;
  };

  networking.hostName = "porygon";

  system.stateVersion = "24.05";
}
