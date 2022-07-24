{ config, pkgs, lib, flake, ... }:
let
  dnsUserConfig = import ../../users/service-accounts/dns.nix;

  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib;
    userConfigs = [ dnsUserConfig ];
  };

  readOnlySharedStore = import ../shared/read-only-store.nix;
  tailscalePreauthKey = import ../shared/tailscale-preauth-key.nix;
  journaldShare =
    import ../common/journald.nix { hostName = config.networking.hostName; };
in {
  inherit users;

  networking = {
    hostName = "igglybuff";
    hostId = "b560563b";
  };

  microvm = {
    vcpu = 1;
    mem = 2048;
    hypervisor = "qemu";
    shares = [ readOnlySharedStore tailscalePreauthKey journaldShare ];
    interfaces = [{
      type = "tap";
      id = "vm-${config.networking.hostName}-01";
      mac = "00:00:00:00:00:01";
    }];
    writableStoreOverlay = null;
  };

  services.openssh.enable = true;

  services.resolved.enable = false;

  networking.resolvconf.extraOptions = [ "ndots:0" ];

  networking.useNetworkd = true;

  systemd.network.networks."00-wired" = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "ipv4";
  };

  imports = [
    (import ../common/machine-id.nix { inherit config flake; })
    ../../modules/agenix
    ../../modules/dnsmasq
    ./options.nix
    (import ../../modules/tailscale {
      inherit config pkgs lib;
      tailnet = "dns";
    })
    ../../modules/time
    ../../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
