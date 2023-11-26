{ config, lib, ... }:
let
  inherit (config) flake;
  inherit (flake.lib.microvm) is-microvm-host bridge-networks;

  enable = is-microvm-host config;

  internalInterfaces = lib.optionals enable (bridge-networks config);

  microvmHostnames =
    if enable then (builtins.attrNames config.microvm.vms) else [ ];

  # Assumption vms value matches that of a nixosConfiguration
  # TODO: add guard to check for attribute
  microvms =
    builtins.map (x: flake.nixosConfigurations."${x}") microvmHostnames;

  # For each microvm, create a network described as per: https://astro.github.io/microvm.nix/simple-network.html#a-simple-network-setup
  # Iteratively creating a 10.0.X.1 interface that serves as a NAT'd bridge
  # for the internal VM
  # There is the obvious issue that if you're running more than 255 VMs
  # this will create addresses that ain't valid. But I don't anticipate this will
  # be an issue.
  microvmNetworks = builtins.foldl' (x: y: x // y) { } (lib.lists.imap0
    (_i: hostName:
      let
        shortHostname =
          builtins.substring 0 7 (builtins.hashString "sha256" hostName);
      in {
        # "10-${shortHostname}-network" = {
        #   matchConfig.Name = "vm-${hostName}*";
        #   networkConfig.Bridge = "${shortHostname}-bridge";
        # };

        # "11-${shortHostname}-network" = {
        #   matchConfig.Name = "${shortHostname}-bridge";
        #   networkConfig.DHCPServer = true;
        #   dhcpServerConfig = {
        #     EmitDNS = true;
        #     DNS = [ "10.0.${builtins.toString i}.1/24" ];
        #     EmitRouter = true;
        #     PoolSize = 1;
        #     PoolOffset = 2;
        #   };
        #   address = [ "10.0.${builtins.toString i}.1/24" ];
        # };

        #         [Match]
        # Name=mymacvlan0

        # [Network]
        # Address=10.10.10.33/32
        # IPForward=yes
        # ConfigureWithoutCarrier=yes

        "00-${shortHostname}-macvlan" = {
          matchConfig.Name = "vm-${hostName}*";
          networkConfig = {
            Bridge = "${shortHostname}-bridge";
            IPForward = "yes";
            ConfigureWithoutCarrier = "yes";
          };
        };

        "10-${shortHostname}-macvlan" = {
          networkConfig = { MACVLAN = "${shortHostname}-macvlan"; };
        };

      }) microvmHostnames);

  microvmNetdevs = builtins.foldl' (x: y: x // y) { } (builtins.map (hostName:
    let
      shortHostname =
        builtins.substring 0 7 (builtins.hashString "sha256" hostName);
    in {
      # "10-${shortHostname}-bridge" = {
      #   netdevConfig = {
      #     Kind = "bridge";
      #     Name = "${shortHostname}-bridge";
      #   };
      # };

      "00-${shortHostname}-macvlan" = {
        netdevConfig = {
          Kind = "macvlan";
          Name = "${shortHostname}-macvlan";
        };

        macvlanConfig = { Mode = "bridge"; };
      };
    }) microvmHostnames);

  journaldRules = builtins.map (microvm:
    let
      inherit (microvm.config.systemd) machineId;
      inherit (microvm.config.networking) hostName;
      # creates a symlink of each MicroVM's journal under the host's /var/log/journal
    in "L+ /var/log/journal/${machineId} - - - - /var/lib/microvms/${hostName}/journal/${machineId}")
    microvms;

  externalInterface = if enable then
    (builtins.head (builtins.filter (interface: interface.useDHCP)
      (builtins.attrValues config.networking.interfaces))).name
  else
    null;
in {

  imports = [ ../../systemd-networkd ];

  nix.settings = {
    substituters = [ "https://microvm.cachix.org/" ];
    trusted-public-keys =
      [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  networking = {
    firewall.allowedUDPPorts = [ 67 ];
    nat = {
      inherit enable;
      enableIPv6 = enable;
      inherit externalInterface;
      inherit internalInterfaces;
    };
  };

  systemd.network = {
    networks = microvmNetworks;
    netdevs = microvmNetdevs;
    tmpfiles.rules = journaldRules;
  };
}
