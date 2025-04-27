{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (self.lib) merge;

  jay = self.common.users.jay {
    inherit config pkgs;
    modules = with self.common.home-manager-module-sets; cli ++ impermanence;
  };

  user-configs = merge [
    jay
  ];
in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    ./disk-config.nix
    agenix
    alloy
    blocky
    generations
    home-manager
    impermanence
    logging
    nix
    nix-topology
    openssh
    ssh
    ssh
    sudo
    time
    timesyncd
    tmp-tmpfs
    zramSwap
    zsh
  ];

  networking.hostName = lib.mkForce "wartortle";

  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  systemd.network = {
    netdevs."00-vlan-dns" = {
      enable = true;
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-dns";
      };
      vlanConfig.Id = 6;
    };

    networks = {
      "00-wired" = {
        enable = true;
        # mkForce is utilised here to override the default systemd
        # settings in the systemd-networkd module
        matchConfig.Name = lib.mkForce "eth0";
        networkConfig = lib.mkForce {
          VLAN = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
        };
      };

      "10-vlan-dns" = {
        enable = true;
        name = config.systemd.network.netdevs."00-vlan-dns".netdevConfig.Name;
        networkConfig.DHCP = "ipv4";
      };
    };
  };
}
