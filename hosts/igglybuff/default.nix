{ config, pkgs, lib, flake, ... }:
let
  tailscaleKey = import ../shared/tailscale-identity-key.nix;
  readOnlySharedStore = import ../shared/read-only-store.nix;
  journaldShare =
    import ../common/journald.nix { inherit (config.networking) hostName; };
in {
  # TODO: replace the below with a user
  # inherit users;
  # users.users.root = {
  #   openssh.authorizedKeys.keys = [
  #     "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMO6FTToBOIByP9uVP2Ke2jGD/ESxPcXEMhvR7unukNGAAAABHNzaDo= jay@rovacsek.com"
  #     "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINNGQz3ekO1q/DrxuhP7Ck3TnP9V4ooF5vo8ibFWKKqFAAAABHNzaDo= jay@rovacsek.com"
  #     "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDuG5e8MReihLwtKk3/rbXcZKNfiapcqAhWu//fC0aMKAAAABHNzaDo= jay@rovacsek.com"
  #     "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDjbVDfVzpcxnx9fl4pBr6eKAJdSyX4JLyBK02N9YeFAAAABHNzaDo= jay@rovacsek.com"
  #   ];
  # };

  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PermitRootLogin = "yes";
  #     PasswordAuthentication = false;
  #   };
  # };
  # networking.firewall.allowedTCPPorts = [ 22 ];

  networking = {
    hostName = "igglybuff";
    hostId = "b560563b";
  };

  microvm = {
    vcpu = 1;
    mem = 2048;
    hypervisor = "qemu";
    shares = [ readOnlySharedStore journaldShare ];
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
