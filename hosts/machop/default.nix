{ config, self, ... }: {
  imports = with self.nixosModules; [
    agenix
    lidarr
    nix-topology
    microvm-guest
    time
    timesyncd
  ];

  networking.hostName = "machop";

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:85";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];

    shares = [
      {
        # On the host
        source = "/srv/music";
        # In the MicroVM
        mountPoint = "/srv/music";
        tag = "music";
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

  services.lidarr = {
    group = "media";
    user = "media";
  };

  system.stateVersion = "24.05";

  users = {
    groups.media = {
      inherit (self.common.networking.services.media.user) gid;
    };
    users.media = {
      group = "media";
      inherit (self.common.networking.services.media.user) uid;
      isSystemUser = true;
    };
  };
}
