{ config, flake, lib }:
let
  meta = import ../meta.nix { inherit config flake; };

  microvmHostnames = (builtins.attrNames config.microvm.vms);

  microvms =
    builtins.map (x: flake.nixosConfigurations."${x}") (microvmHostnames);

  # For each microvm, create a network described as per: https://astro.github.io/microvm.nix/simple-network.html#a-simple-network-setup
  # Iteratively creating a 10.0.X.1 interface that serves as a NAT'd bridge
  # for the internal VM
  # There is the obvious issue that if you're running more than 255 VMs
  # this will create addresses that ain't valid. But I don't anticipate this will
  # be an issue.
  microvmNetworks = builtins.foldl' (x: y: x // y) { } (lib.lists.imap0
    (i: hostName:
      let
        shortHostname =
          builtins.substring 0 7 (builtins.hashString "sha256" hostName);
      in {
        "00-${hostName}-network" = {
          matchConfig.Name = "${shortHostname}-bridge";
          networkConfig.DHCPServer = false;
          addresses =
            [{ addressConfig.Address = "10.0.${builtins.toString i}.1/24"; }];
        };

        "01-${hostName}-network" = {
          matchConfig.Name = "vm-${hostName}-*";
          networkConfig.Bridge = "${shortHostname}-bridge";
        };
      }) microvmHostnames);

  microvmNetdevs = builtins.foldl' (x: y: x // y) { } (builtins.map (hostName:
    let
      shortHostname =
        builtins.substring 0 7 (builtins.hashString "sha256" hostName);
    in {
      "00-${hostName}-bridge" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "${shortHostname}-bridge";
        };
      };
    }) microvmHostnames);

  journaldRules = builtins.map (microvm:
    let
      machineId = microvm.config.systemd.machineId;
      hostName = microvm.config.networking.hostName;
      # creates a symlink of each MicroVM's journal under the host's /var/log/journal
    in "L+ /var/log/journal/${machineId} - - - - /var/lib/microvms/${hostName}/journal/${machineId}")
    (microvms);
in {

  imports = [ ../../systemd-networkd ];

  networking = {
    nat = {
      enable = meta.isMicrovmHost;
      enableIPv6 = false;
      externalInterface = if meta.isMicrovmHost then "phys0" else null;
      internalInterfaces =
        if meta.isMicrovmHost then meta.bridgeNetworks else [ ];
    };
  };

  systemd.network.links = {
    "10-phys0" = {
      enable = meta.isMicrovmHost;
      matchConfig = {
        Name = "en*";
        Virtualization = "!qemu";
      };
      linkConfig.Name = "phys0";
    };
  };

  systemd.network.networks = microvmNetworks;
  systemd.network.netdevs = microvmNetdevs;
  systemd.tmpfiles.rules = journaldRules;

}
