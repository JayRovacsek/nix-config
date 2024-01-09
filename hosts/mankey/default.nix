{ config, flake, ... }: {
  inherit flake;

  # Below required to build deluge-gtk
  environment.noXlibs = false;

  fileSystems."/mnt/zfs/downloads".neededForBoot = true;

  networking.hostName = "mankey";

  microvm = {
    # TODO: determine best approach to passing secrets into microvms.
    # This'll likely end up being a mount of the requisite decryption
    # keys so we can just use age directly as happens in all modules currently.
    shares = [{
      # On the host
      source = config.services.deluge.config.download_location;
      # In the MicroVM
      mountPoint = config.services.deluge.config.download_location;
      tag = "linux-isos";
      proto = "virtiofs";
    }];
    interfaces = [{
      type = "macvtap";
      id = config.networking.hostName;
      mac = "02:42:c0:a8:04:82";
      macvtap = {
        link = "download";
        mode = "bridge";
      };
    }];
  };

  services.deluge.config.download_location = "/mnt/zfs/downloads";
}
