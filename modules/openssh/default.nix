{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
