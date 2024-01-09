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
        source = "/mnt/zfs/tv";
        # In the MicroVM
        mountPoint = "/srv/tv";
        tag = "tv";
        proto = "virtiofs";
      }
      {
        # On the host
        source = "/mnt/zfs/downloads";
        # In the MicroVM
        mountPoint = "/srv/downloads";
        tag = "linux-isos";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "bellsprout";

  services.sonarr.group = "download";

  users = {
    users.sonarr.uid = 274;
    groups = {
      download = {
        gid = 10005;
        members = [ "sonarr" ];
      };
      media = {
        gid = 10002;
        members = [ "sonarr" ];
      };
    };
  };

}
