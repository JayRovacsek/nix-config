{ config, self, ... }:
{
  imports = with self.nixosModules; [
    agenix
    grafana-agent
    nix-topology
    microvm-guest
    radarr
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:84";
        macvtap = {
          link = "download";
          mode = "bridge";
        };
      }
    ];

    mem = 1024;

    shares = [
      {
        # On the host
        source = "/srv/movies";
        # In the MicroVM
        mountPoint = "/srv/movies";
        tag = "movies";
        proto = "virtiofs";
      }
      {
        # On the host
        source = "/srv/downloads";
        # In the MicroVM
        mountPoint = "/srv/downloads";
        tag = "linux-isos";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "poliwag";

  services.radarr = {
    group = "media";
    user = "media";
  };

  system.stateVersion = "24.05";

  users = {
    groups.media = {
      inherit (self.common.config.services.media.user) gid;
    };
    users.media = {
      group = "media";
      inherit (self.common.config.services.media.user) uid;
      isSystemUser = true;
    };
  };
}
