{ config, self, ... }: {
  # Below required to build deluge-gtk
  environment.noXlibs = false;

  fileSystems.${config.services.deluge.config.download_location}.neededForBoot =
    true;

  imports = with self.nixosModules; [
    agenix
    deluge
    gids
    microvm-guest
    time
    timesyncd
    uids
  ];

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

    mem = 1024;

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

  services.deluge = {
    config.download_location = "/srv/downloads";
    user = "media";
    group = "media";
  };

  system.stateVersion = "24.05";

  users = {
    groups.media.gid = config.ids.gids.media;
    users.media = {
      group = "media";
      uid = config.ids.uids.media;
      isSystemUser = true;
    };
  };
}
