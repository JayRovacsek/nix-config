{ interface ? "eth0", ... }: {
  networking = {
    vlans.dns = {
      inherit interface;
      id = 6;
    };
    interfaces.dns.useDHCP = true;
    defaultGateway = "192.168.${vlans.dns.id}.1";
  };
}
