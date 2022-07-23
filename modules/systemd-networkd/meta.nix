{ config }:
let
  hasMicrovm = if builtins.hasAttr "microvm" config then true else false;

  isMicrovmHost =
    if hasMicrovm then builtins.hasAttr "vms" config.microvm else false;

  isMicrovmGuest =
    if hasMicrovm then builtins.hasAttr "hypervisor" config.microvm else false;
  # there may be reason for a host to be both a guest and host
  isRecursiveMicrovm = if isMicrovmHost && isMicrovmGuest then true else false;

  macvlans = builtins.map (x: x.netdevConfig.Name)
    (builtins.filter (x: x.netdevConfig.Kind == "macvlan" && x.enable == true)
      (builtins.attrValues config.systemd.network.netdevs));

  vlans = builtins.map (x: x.netdevConfig.Name)
    (builtins.filter (x: x.netdevConfig.Kind == "vlan" && x.enable == true)
      (builtins.attrValues config.systemd.network.netdevs));

  bridgeNetworks = builtins.map (x: x.netdevConfig.Name)
    (builtins.filter (x: x.netdevConfig.Kind == "bridge" && x.enable == true)
      (builtins.attrValues config.systemd.network.netdevs));

  meta = {
    inherit hasMicrovm isMicrovmGuest isMicrovmHost isRecursiveMicrovm macvlans
      vlans bridgeNetworks;
  };

in meta
