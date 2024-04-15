{ config, self, ... }: {
  environment.noXlibs = false;

  imports = with self.nixosModules; [
    agenix
    microvm-guest
    nix-topology
    sonarr
    time
    timesyncd
  ];

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:83";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];

    shares = [
      {
        # On the host
        source = "/srv/tv";
        # In the MicroVM
        mountPoint = "/srv/tv";
        tag = "tv";
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

  networking.hostName = "bellsprout";

  services.sonarr = {
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
