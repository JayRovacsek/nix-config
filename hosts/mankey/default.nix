{ config, flake, ... }: {
  inherit flake;

  # Below required to build deluge-gtk
  environment.noXlibs = false;

  fileSystems."/mnt/zfs/downloads".neededForBoot = true;

  microvm = {
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:82";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];

    shares = [{
      # On the host
      source = config.services.deluge.config.download_location;
      # In the MicroVM
      mountPoint = config.services.deluge.config.download_location;
      tag = "linux-isos";
      proto = "virtiofs";
    }];
  };

  networking.hostName = "mankey";

  services.deluge.config.download_location = "/mnt/zfs/downloads";
}
