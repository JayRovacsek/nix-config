{ config, pkgs, lib, flake, ... }:
let
  dnsUserConfig = import ../../users/service-accounts/dns.nix;

  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib;
    userConfigs = [ dnsUserConfig ];
  };

  tailscaleKey = import ../shared/tailscale-identity-key.nix;
  readOnlySharedStore = import ../shared/read-only-store.nix;
  journaldShare =
    import ../common/journald.nix { inherit (config.networking) hostName; };
in {
  inherit users;

  services.tailscale.tailnet = "dns";

  networking = {
    hostName = "igglybuff";
    hostId = "b560563b";
  };

  microvm = {
    vcpu = 1;
    mem = 2048;
    hypervisor = "qemu";
    shares = [ readOnlySharedStore tailscaleKey journaldShare ];
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
    ./options.nix
    ../../modules/agenix
    ../../modules/dnsmasq
    ../../modules/microvm/guest
    ../../modules/tailscale
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
