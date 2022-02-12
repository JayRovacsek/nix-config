{
  # Basic networking config, open ports/set VLAN interfaces etc as per
  # https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=networking.
  networking = {
    hostName = "${hostname}";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ ];
  };
}
