{ config, pkgs, lib, ... }:
let meta = import ./meta.nix { inherit config; };
in {
  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;

    nat = {
      enable = meta.isMicrovmHost;
      enableIPv6 = false;
      externalInterface = if meta.isMicrovmHost then "phys0" else null;
      internalInterfaces = [ "microvm" ];
    };
  };

  networking.networkmanager.enable = false;

  imports = [ ./links.nix ./networks.nix ./netdevs.nix ];

  systemd.services.systemd-networkd-wait-online.enable = false;
}
