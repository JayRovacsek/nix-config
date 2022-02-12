{
  networking = {
    hostName = "alakazam";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 ];
  };
}
