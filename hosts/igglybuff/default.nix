{ config, pkgs, lib, flake, ... }:
let
  dnsUserConfig = import ../../users/service-accounts/dns.nix;

  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs;
    userConfigs = [ dnsUserConfig ];
  };

  readOnlySharedStore = import ../shared/read-only-store.nix;
  tailscalePreauthKey = import ../shared/tailscale-dns-preauth-key.nix;
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
      id = "vm-dns-01";
      mac = "02:42:c0:a8:06:08";
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
    networkConfig = { Address = "10.0.0.2/24"; };
    routes = [
      {
        routeConfig = {
          Gateway = "10.0.0.1";
          Destination = "0.0.0.0/0";
          Metric = 1024;
        };
      }
      {
        routeConfig = {
          Gateway = "10.0.0.1";
          Destination = "10.0.0.0/24";
          Metric = 1024;
        };
      }
    ];
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
