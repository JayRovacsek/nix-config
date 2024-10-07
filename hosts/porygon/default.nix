{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    bedrock-connect
    geyser-minecraft-server
    grafana-agent
    microvm-guest
    nix-topology
    time
    timesyncd
    valheim
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

  services.minecraft-server.dataDir = "/srv/games/servers/minecraft/oct-2024";

  system.stateVersion = "24.05";

  virtualisation.oci-containers.containers.valheim.volumes = [
    "/srv/games/servers/valheim/2024-valheim-server/config:/config"
    "/srv/games/servers/valheim/2024-valheim-server/data:/opt/valheim"
  ];
}
