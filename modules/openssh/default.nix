_: {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
