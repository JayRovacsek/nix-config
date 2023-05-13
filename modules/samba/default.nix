{ config, ... }: {
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = ${config.networking.hostName}
      netbios name = ${config.networking.hostName}
      security = user 
      hosts allow = 192.168.1.0/24 192.168.8.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      isos = {
        path = "/mnt/zfs/isos";
        browseable = "yes";
        "read only" = true;
        "guest ok" = "yes";
        comment = "Public ISO Share";
      };
      downloads = {
        path = "/mnt/zfs/downloads";
        browseable = "yes";
        "read only" = true;
        "guest ok" = "yes";
        comment = "Public Download Share";
      };
    };
  };

  firewall = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };
}
