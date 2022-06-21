{ config, pkgs, ... }:
let
  dnsUserConfig = import ../users/service-accounts/dns.nix;

  userConfigs = import ./users.nix;

  # Helper functions for generating correct nix configs
  serviceUserFunction = import ../functions/service-user.nix;
  userFunction = import ../functions/map-reduce-users.nix;

  # Actual constructs used to generate useful config
  dnsUser = serviceUserFunction { userConfig = dnsUserConfig; };
  users = userFunction { inherit pkgs userConfigs; };

  readOnlySharedStore = import ./shared/read-only-store.nix;
in {
  users = users // dnsUser;

  networking = {
    hostName = "igglybuff";
    hostId = "b560563b";
  };

  microvm = {
    vcpu = 1;
    mem = 2048;
    hypervisor = "qemu";
    shares = [ readOnlySharedStore ];
    interfaces = [{
      type = "tap";
      id = "vm-dns-01";
      mac = "02:42:c0:a8:06:08";
    }];
    writableStoreOverlay = null;
  };

  environment.systemPackages = with pkgs; [ dnsutils ];

  services.openssh.enable = true;
  services.resolved.enable = false;

  networking.resolvconf.extraOptions = [ "ndots:0" ];

  imports = [
    ../modules/dnsmasq
    ../modules/systemd-networkd
    ../modules/time
    ../modules/timesyncd
  ];

  system.stateVersion = "22.11";
}
