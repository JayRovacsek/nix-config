{ config, flake, ... }: {
  inherit flake;

  networking.hostName = "poliwag";

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
        source = "/mnt/zfs/movies";
        # In the MicroVM
        mountPoint = "/srv/movies";
        tag = "movies";
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

  services.radarr.group = "download";

  users = {
    users.radarr.uid = 275;
    groups = {
      download = {
        gid = 10005;
        members = [ "radarr" ];
      };
      media = {
        gid = 10002;
        members = [ "radarr" ];
      };
    };
  };
}
