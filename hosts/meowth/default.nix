{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    grafana-agent
    microvm-guest
    prowlarr
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "meowth";

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:89";
        macvtap = {
          link = "download";
          mode = "bridge";
        };
      }
    ];
  };

  system.stateVersion = "24.05";
}
