{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    alloy
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

    shares = [
      {
        # On the host
        source = "/srv/games/servers";
        # In the MicroVM
        mountPoint = "/srv/games/servers";
        tag = "game-server-files";
        proto = "virtiofs";
      }
    ];
    vcpu = 4;
  };

  networking.hostName = "porygon";

  system.stateVersion = "24.05";

}
