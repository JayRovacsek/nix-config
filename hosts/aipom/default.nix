{ config, pkgs, lib, flake, ... }:
let
  inherit (flake.lib.microvm) generate-journald-share;
  inherit (flake.common.microvm) read-only-store;
  inherit (config.networking) hostName;

  journald-share = generate-journald-share hostName;
in {
  networking = {
    hostName = "aipom";
    hostId = "0f5cb1b8";
  };

  microvm = {
    vcpu = 1;
    mem = 1024;
    hypervisor = "cloud-hypervisor";
    shares = [ read-only-store journald-share ];
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
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
