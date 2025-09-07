{
  config,
  lib,
  self,
  ...
}:
{
  imports = with self.nixosModules; [
    agenix
    alloy
    blocky
    buildbot-coordinator
    logging
    microvm-guest
    nix-topology
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:05:05";
        macvtap = {
          link = "reverse-proxy";
          mode = "bridge";
        };
      }
    ];

    shares = [
      {
        # On the host
        source = "/srv/databases/buildbot";
        # In the MicroVM
        mountPoint = "/var/lib/postgresql";
        tag = "nextcloud";
        proto = "virtiofs";
      }
    ];
  };

  networking = {
    dhcpcd.enable = false;
    hostName = "magnemite";
    networkmanager.enable = false;
    useNetworkd = true;
  };

  # This is extremely important as this host does not utilise the
  # systemd networkd module, therefore not inheriting the
  # disabled resolved service.
  #
  # Blocky doesn't like that punk resolvd taking 53 off them
  services.resolved.enable = false;

  system.stateVersion = "25.05";

  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}
