{ config, flake, ... }: {
  inherit flake;

  networking.hostName = "nidoking";

  microvm = {
    balloonMem = 2048;

    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:0a:03";
      macvtap = {
        link = "nextcloud";
        mode = "bridge";
      };
    }];

    mem = 2048;

    shares = [{
      # On the host
      source = "/mnt/zfs/nextcloud";
      # In the MicroVM
      mountPoint = "/srv/nextcloud";
      tag = "nextcloud";
      proto = "virtiofs";
    }];
  };
}
