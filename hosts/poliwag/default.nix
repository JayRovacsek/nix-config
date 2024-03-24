{ config, self, ... }: {
  imports = with self.nixosModules; [
    agenix
    gids
    microvm-guest
    radarr
    time
    timesyncd
    uids
  ];

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:84";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];

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
    groups.media.gid = config.ids.gids.media;
    users.media = {
      group = "media";
      uid = config.ids.uids.media;
      isSystemUser = true;
    };
  };
}
