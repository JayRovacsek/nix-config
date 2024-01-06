{ config, flake, ... }: {
  inherit flake;

  # Below required to build deluge-gtk
  environment.noXlibs = false;

  fileSystems = {
    "/agenix".neededForBoot = true;
    "/mnt/zfs/downloads".neededForBoot = true;
  };

  networking.hostName = "mankey";

  microvm = {
    # TODO: determine best approach to passing secrets into microvms.
    # This'll likely end up being a mount of the requisite decryption
    # keys so we can just use age directly as happens in all modules currently.
    shares = [
      {
        # On the host
        source = "/agenix/${config.networking.hostName}";
        # In the MicroVM
        mountPoint = "/agenix";
        tag = "id-ed25519-wireless-primary";
        proto = "virtiofs";
      }
      {
        # On the host
        source = config.services.deluge.config.download_location;
        # In the MicroVM
        mountPoint = config.services.deluge.config.download_location;
        tag = "linux-isos";
        proto = "virtiofs";
      }
      {
        # On the host
        source = config.services.deluge.dataDir;
        # In the MicroVM
        mountPoint = config.services.deluge.dataDir;
        tag = "config-directory";
        proto = "virtiofs";
      }
    ];
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
