{ config, self, ... }:
{
  fileSystems.${config.services.deluge.config.download_location}.neededForBoot =
    true;

  imports = with self.nixosModules; [
    agenix
    alloy
    deluge
    microvm-guest
    nix-topology
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:04:82";
        macvtap = {
          link = "download";
          mode = "bridge";
        };
      }
    ];

    mem = 1024;

    shares = [
      {
        # On the host
        source = config.services.deluge.config.download_location;
        # In the MicroVM
        mountPoint = config.services.deluge.config.download_location;
        tag = "linux-isos";
        proto = "virtiofs";
      }
    ];
  };

  networking.hostName = "mankey";

  services.deluge = {
    config.download_location = "/srv/downloads";
    user = "media";
    group = "media";
  };

  system.stateVersion = "24.05";

  users = {
    inherit (self.common.config.services.media) groups users;
  };
}
