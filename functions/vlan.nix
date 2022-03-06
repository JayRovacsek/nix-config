{ vlanConfig ? {
  interface = "eth0";
  name = "vlan";
  id = 99;
}, ... }: {
  networking.vlans.${vlanConfig.name} = {
    interface = vlanConfig.interface;
    id = vlanConfig.id;
  };
  networking.interfaces.${vlanConfig.name}.useDHCP = true;
}
