{ config ? {
  interface = "eth0";
  name = "vlan";
  id = 99;
}, ... }: {
  networking.vlans.${config.name} = {
    interface = config.interface;
    id = config.id;
  };
  networking.interfaces.${config.name}.useDHCP = true;
}
