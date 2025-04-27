{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    flaresolverr
    microvm-guest
    nix-topology
    time
    timesyncd
  ];

  networking.hostName = "slowpoke";

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:8a";
        macvtap = {
          link = "download";
          mode = "bridge";
        };
      }
    ];

    mem = 1024;
  };

  system.stateVersion = "24.05";
}
