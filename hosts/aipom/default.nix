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
    hostName = "aipom";
    hostId = "0f5cb1b8";
  };

  microvm = {
    vcpu = 1;
    mem = 1024;
    hypervisor = "qemu";
    interfaces = [{
      type = "tap";
      id = "vm-${config.networking.hostName}-01";
      mac = "00:00:00:00:00:01";
    }];
    writableStoreOverlay = null;
  };

  imports = [
    ../common/machine-id.nix
    ../../modules/microvm/guest
    ../../modules/ombi
    ../../modules/openssh
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
