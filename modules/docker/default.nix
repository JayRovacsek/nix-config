{ config, pkgs, ... }:
let
  configs = {
    aarch64-linux = import ./aarch64-linux.nix;
    x86_64-linux = import ./x86_64-linux.nix;
  };

  zfsBootSupported =
    builtins.any (x: x == "zfs") config.boot.supportedFilesystems;

  zfsServiceSupported = config.services.zfs.autoScrub.enabled
    || config.services.zfs.autoScrub.enabled;

  systemdUnitConfigs = {
    systemd.services.docker.after =
      if zfsBootSupported || zfsServiceSupported then
        [ "zfs-mount.service" ]
      else
        [ ];

    systemd.services.docker.unitConfig.RequiresMountsFor = "/var/lib/docker";

  };

in { virtualisation.docker = configs.${pkgs.system}; } // systemdUnitConfigs
