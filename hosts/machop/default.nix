{ config, flake, ... }: {
  inherit flake;

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
        source = "/mnt/zfs/music";
        # In the MicroVM
        mountPoint = "/srv/music";
        tag = "music";
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

  services.lidarr.group = "download";

  users = {
    users.lidarr.uid = 306;
    groups = {
      download = {
        gid = 10005;
        members = [ "lidarr" ];
      };
      media = {
        gid = 10002;
        members = [ "lidarr" ];
      };
    };
  };
}
