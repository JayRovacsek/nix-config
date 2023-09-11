_: {
  networking.firewall.allowedUDPPorts = [ 123 ];

  services.openntpd = {
    enable = true;
    extraConfig = ''
      listen on *
    '';
    servers = [
      "0.au.pool.ntp.org"
      "1.au.pool.ntp.org"
      "2.au.pool.ntp.org"
      "3.au.pool.ntp.org"
    ];
  };
}
