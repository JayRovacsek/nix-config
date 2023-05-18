{ config, ... }: {
  networking = {
    vlans = {
      download-vlan = {
        id = 4;
        interface = "download";
      };
    };

    interfaces = {
      download = {
        name = "download";
        useDHCP = false;
        virtual = true;
        # ipv4.addresses = [{
        #   address = "192.168.4.1";
        #   prefixLength = 16;

        # }];
      };
    };
  };
  containers = {
    deluge = {
      config = { ... }: {
        imports = [ ../../modules/deluge ];
        system.stateVersion = "23.05";
      };
      ephemeral = true;

      macvlans = [ "download" ];
    };
  };
}
