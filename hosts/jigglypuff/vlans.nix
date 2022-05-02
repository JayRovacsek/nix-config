{ config, ... }:
let
  vlanFunction = import ../../functions/vlan.nix;
  vlanConfig = import ../../vlans/dns.nix { interface = "eth0"; };
  dns = vlanFunction { inherit vlanConfig; };
in {
  networking.vlans = dns.networking.vlans;
  networking.interfaces = dns.networking.interfaces;
}
