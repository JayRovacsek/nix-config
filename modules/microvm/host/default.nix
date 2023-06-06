{ config, lib, ... }:
let
  inherit (config) flake;
  inherit (flake.lib.microvm) is-microvm-host;

  enable = is-microvm-host config;

  # Assumption vms value matches that of a nixosConfiguration
  # TODO: add guard to check for attribute

  # For each microvm, create a network described as per: https://astro.github.io/microvm.nix/simple-network.html#a-simple-network-setup
  # Iteratively creating a 10.0.X.1 interface that serves as a NAT'd bridge
  # for the internal VM
  # There is the obvious issue that if you're running more than 255 VMs
  # this will create addresses that ain't valid. But I don't anticipate this will
  # be an issue.
in {

  # imports = [ ../../systemd-networkd ];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  networking = {
    nat = {
      inherit enable;
      enableIPv6 = enable;
    };
  };

  networking.firewall.allowedUDPPorts = [ 67 ];
}
