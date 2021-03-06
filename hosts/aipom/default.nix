{ config, pkgs, lib, flake, ... }:
let
  readOnlySharedStore = import ../shared/read-only-store.nix;
  tailscalePreauthKey = import ../shared/tailscale-preauth-key.nix;
  journaldShare =
    import ../common/journald.nix { hostName = config.networking.hostName; };
in {

  networking = {
    hostName = "aipom";
    hostId = "0f5cb1b8";
  };

  microvm = {
    vcpu = 1;
    mem = 1024;
    hypervisor = "qemu";
    shares = [ readOnlySharedStore tailscalePreauthKey journaldShare ];
    interfaces = [{
      type = "tap";
      id = "vm-${config.networking.hostName}-01";
      mac = "00:00:00:00:00:01";
    }];
    writableStoreOverlay = null;
  };

  imports = [
    (import ../common/machine-id.nix { inherit config flake; })
    ../../modules/agenix
    ./options.nix
    (import ../../modules/microvm/guest { inherit config flake lib; })
    ../../modules/ombi
    (import ../../modules/tailscale {
      inherit config pkgs lib;
      tailnet = "general";
    })
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
