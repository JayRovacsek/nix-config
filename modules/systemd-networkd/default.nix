{ config, pkgs, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;

    nat = mkIf meta.isMicrovmHost {
      enable = true;
      enableIPv6 = false;
      externalInterface = "phys0";
      internalInterfaces = [ "microvm" ];
    };
  };

  networking.networkmanager.enable = false;

  imports = [ ./links.nix ./networks.nix ./netdevs.nix ];

  systemd.services.systemd-networkd-wait-online.enable = false;
}
