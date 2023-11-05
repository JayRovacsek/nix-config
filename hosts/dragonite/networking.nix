{
  ## Todo: write out the below - need to rework networking module.
  networking = {
    wireless.enable = false;
    hostId = "acd009f4";
    hostName = "dragonite";
    useDHCP = false;
    interfaces.enp9s0.useDHCP = true;
    nameservers = [ "127.0.0.1" ];

    firewall = {
      ## TODO: remove below as they can be abstracted into microvms
      # For reference:
      # 8200: Duplicati
      allowedTCPPorts = [ 8200 ];
    };
  };
}
