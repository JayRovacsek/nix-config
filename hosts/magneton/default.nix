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
    buildbot-worker
    logging
    microvm-guest
    nix
    nix-topology
    remote-builds
    time
    timesyncd
  ];

  microvm = {
    interfaces = [
      {
        type = "macvtap";
        id = config.networking.hostName;
        mac = "02:42:c0:a8:05:06";
        macvtap = {
          link = "reverse-proxy";
          mode = "bridge";
        };
      }
    ];

    mem = 32768;
    vcpu = 10;

    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = config.microvm.writableStoreOverlay;
        size = 1024 * 100;
        fsType = "ext4";
      }
    ];
  };

  nix.settings.auto-optimise-store = lib.mkForce false;

  networking = {
    dhcpcd.enable = false;
    hostName = "magneton";
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
