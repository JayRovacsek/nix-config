{ config, pkgs, ... }: {
  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;
  };

  networking.networkmanager.enable = false;

  systemd.network = {
    enable = true;

    networks = import ./networks.nix;
    netdevs = import ./netdevs.nix;
  };

  systemd.services.systemd-networkd-wait-online.enable = false;
}
