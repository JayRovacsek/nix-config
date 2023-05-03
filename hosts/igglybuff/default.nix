{ config, pkgs, lib, flake, ... }:
let
  inherit (flake) common;
  inherit (flake.lib) merge;
  inherit (config.networking) hostName;

  jay = common.users.jay {
    inherit config pkgs;
    modules = [ ];
    overrides = { users.users.jay.shell = pkgs.bash; };
  };

  merged = merge [ jay ];

in {
  inherit flake;
  inherit (merged) users;

  networking = {
    hostName = "igglybuff";
    hostId = "b560563b";
  };

  microvm = {
    vcpu = 1;
    mem = 2048;
    hypervisor = "qemu";
    interfaces = [{
      type = "tap";
      id = "vm-${hostName}-01";
      mac = "00:00:00:00:00:01";
    }];
    writableStoreOverlay = null;
  };

  services.resolved.enable = false;

  imports = [
    ../common/machine-id.nix
    ../../modules/blocky
    ../../modules/microvm/guest
    ../../modules/openssh
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
