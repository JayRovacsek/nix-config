{ config, flake }:
let
  hasMicrovm = if builtins.hasAttr "microvm" config then true else false;

  isMicrovmHost =
    if hasMicrovm then builtins.hasAttr "vms" config.microvm else false;

  isMicrovmGuest =
    if hasMicrovm then builtins.hasAttr "hypervisor" config.microvm else false;
  # there may be reason for a host to be both a guest and host
  isRecursiveMicrovm = if isMicrovmHost && isMicrovmGuest then true else false;

  # macvlans = builtins.map (x: x.netdevConfig.Name)
  #   (builtins.filter (x: x.netdevConfig.Kind == "macvlan" && x.enable == true)
  #     (builtins.attrValues config.systemd.network.netdevs));

  # vlans = builtins.map (x: x.netdevConfig.Name)
  #   (builtins.filter (x: x.netdevConfig.Kind == "vlan" && x.enable == true)
  #     (builtins.attrValues config.systemd.network.netdevs));

  bridgeNetworks = builtins.map (x: x.netdevConfig.Name)
    (builtins.filter (x: x.netdevConfig.Kind == "bridge" && x.enable)
      (builtins.attrValues config.systemd.network.netdevs));

  # microvmHosts = builtins.filter
  #   (x: builtins.hasAttr "microvm" x.config && builtins.hasAttr "vms" x.config)
  #   (builtins.attrValues
  #     (builtins.trace flake.nixosConfigurations flake.nixosConfigurations));

  # microvmGuests = builtins.filter
  #   (x: builtins.hasAttr "microvm" x.config && builtins.hasAttr "cpu" x.config)
  #   (builtins.attrValues
  #     (builtins.trace flake.nixosConfigurations flake.nixosConfigurations));

  meta = {
    inherit hasMicrovm isMicrovmGuest isMicrovmHost isRecursiveMicrovm
      bridgeNetworks;
  };

in meta
