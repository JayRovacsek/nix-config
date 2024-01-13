{ config, flake, ... }: {
  inherit flake;

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

  users = {
    groups.media.gid = config.ids.gids.media;
    users.media = {
      group = "media";
      uid = config.ids.uids.media;
      isSystemUser = true;
    };
  };
}
