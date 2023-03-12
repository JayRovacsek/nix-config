{ config, pkgs, lib, flake, ... }:
let
  inherit (flake.lib.microvm) generate-journald-share;
  inherit (flake.common.microvm) read-only-store;
  inherit (config.networking) hostName;

  journald-share = generate-journald-share hostName;
in {
  networking = {
    hostName = "igglybuff";
    hostId = "b560563b";
  };

  microvm = {
    vcpu = 1;
    mem = 2048;
    hypervisor = "cloud-hypervisor";
    shares = [ read-only-store journald-share ];
    interfaces = [{
      type = "tap";
      id = "vm-${config.networking.hostName}-01";
      mac = "00:00:00:00:00:01";
    }];
    writableStoreOverlay = null;
  };

  services.resolved.enable = false;

  networking.resolvconf.extraOptions = [ "ndots:0" ];

  imports = [
    ../common/machine-id.nix
    ../../modules/dnsmasq
    ../../modules/microvm/guest
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
