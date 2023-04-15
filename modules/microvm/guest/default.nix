{
  networking.useNetworkd = true;

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  systemd.network.networks."00-wired" = {
    enable = true;
    matchConfig.Name = "enp*";
    networkConfig.DHCP = "yes";
  };
}
