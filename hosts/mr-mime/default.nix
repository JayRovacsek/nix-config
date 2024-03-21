{ config, ... }: {

  networking.hostName = "mr-mime";

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:12:02";
      macvtap = {
        link = "log";
        mode = "bridge";
      };
    }];

    shares = [{
      # On the host
      source = "/srv/logs/loki";
      # In the MicroVM
      mountPoint = config.services.loki.dataDir;
      tag = "nextcloud";
      proto = "virtiofs";
    }];
  };

  system.stateVersion = "24.05";
}
