{ vlanConfig, ... }: {
  networking.vlans.${vlanConfig.name} = {
    interface = vlanConfig.interface;
    id = vlanConfig.id;
  };
  networking.interfaces.${vlanConfig.name}.useDHCP = true;
}
