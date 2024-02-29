{ config, lib, ... }:
let
  zfsBootSupported =
    (lib.filterAttrs (n: v: n == "zfs" && v) config.boot.supportedFilesystems)
    != { };

  zfsServiceSupported = config.services.zfs.autoScrub.enable
    || config.services.zfs.autoSnapshot.enable;

  enableNvidia =
    builtins.any (x: x == "nvidia") config.services.xserver.videoDrivers;

in {
  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      inherit enableNvidia;
      enable = true;
      rootless.enable = true;
      autoPrune.enable = true;
    };
  };

  systemd.services.docker.after =
    lib.optionals (zfsBootSupported || zfsServiceSupported)
    [ "zfs-mount.service" ];
  systemd.services.docker.unitConfig.RequiresMountsFor = "/var/lib/docker";
}
