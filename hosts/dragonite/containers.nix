{
  config,
  lib,
  self,
  ...
}:

let

  containerHostnames = builtins.attrNames config.containers;

  path-file = s: lib.last (lib.splitString "/" s);

  agenixRules = builtins.foldl' (
    acc: container:
    acc
    ++ (builtins.map (
      y:
      "C /agenix/${
        config.containers.${container}.config.systemd.machineId
      }/${path-file y} - - - - ${y}"
    ) config.containers.${container}.config.age.identityPaths)
  ) [ ] containerHostnames;

  parent = "10-wired";

  inherit (lib)
    mapAttrsToList
    concatLists
    unique
    ;

  # Extract all bind mount host paths from all containers
  bindMountHostPaths = unique (
    concatLists (
      mapAttrsToList (
        _containerName: containerCfg:
        mapAttrsToList (_mountName: mountCfg: mountCfg.hostPath) (
          containerCfg.bindMounts or { }
        )
      ) (config.containers or { })
    )
  );

  varLibRules = builtins.map (
    path: "d ${path} 0755 root root - -"
  ) bindMountHostPaths;

  partyMembers = [
    "bellsprout"
    "igglybuff"
    "machop"
    # "magikarp"
    "mankey"
    "meowth"
    "nidorino"
    # "mr-mime"
    "poliwag"
    "slowpoke"
  ];

  partyCommonConfigs = builtins.filter (
    x: builtins.elem x.hostname partyMembers
  ) (builtins.attrValues self.common.config.hosts);

  partyVlans = builtins.filter (
    x: builtins.elem x.name (builtins.map (x: x.vlan) partyCommonConfigs)
  ) self.common.config.networks;

  vlans = builtins.map (x: {
    inherit (x) name vlan-tag;
    bridge = "br-${x.name}";
  }) partyVlans;

  party = builtins.map (x: {
    name = x.hostname;
    inherit (x) macAddress vlan shares;
  }) partyCommonConfigs;
in
{
  systemd.tmpfiles.rules = varLibRules ++ agenixRules;

  containers = builtins.foldl' (
    acc: pokemon:
    lib.recursiveUpdate acc {
      "${pokemon.name}" = {
        autoStart = true;

        ephemeral = true;

        privateNetwork = true;

        localMacAddress = pokemon.macAddress;
        hostBridge = "br-${pokemon.vlan}";

        bindMounts = {
          host = {
            hostPath = "/var/lib/${builtins.hashString "md5" pokemon.name}";
            mountPoint = "/var/lib";
            isReadOnly = false;
          };
          agenix = {
            hostPath = "/agenix/${builtins.hashString "md5" pokemon.name}";
            mountPoint = "/agenix";
            isReadOnly = false;
          };
        }
        //
          (builtins.foldl' (
            acc: share:
            acc
            // {
              "${share.name}" = {
                inherit (share)
                  hostPath
                  mountPoint
                  isReadOnly
                  ;
              };
            }
          ) { })
            pokemon.shares;

        specialArgs = { inherit self; };

        config = _: {
          age = {
            identityPaths = [
              "/agenix/id-ed25519-${pokemon.name}-primary"
            ];
          };
          imports = [ ../${pokemon.name} ];
        };
      };
    }
  ) { } party;

  systemd.network = {
    #
    # VLAN devices
    #
    netdevs = builtins.foldl' (
      acc: vlan:
      lib.recursiveUpdate acc {

        #
        # VLAN netdev
        #
        "00-${vlan.name}" = {
          netdevConfig = {
            Kind = "vlan";
            Name = vlan.name;
          };

          vlanConfig.Id = vlan.vlan-tag;
        };

        #
        # Bridge netdev
        #
        "10-${vlan.bridge}" = {
          netdevConfig = {
            Kind = "bridge";
            Name = vlan.bridge;
          };
        };
      }
    ) { } vlans;

    networks = builtins.foldl' (
      acc: vlan:
      lib.recursiveUpdate acc {

        #
        # Parent NIC gets VLAN attached
        #
        "${parent}" = {
          vlan = (acc.${parent}.vlan or [ ]) ++ [ vlan.name ];
        };

        #
        # VLAN interface joins bridge
        #
        "20-${vlan.name}" = {
          matchConfig.Name = vlan.name;

          networkConfig = {
            Bridge = vlan.bridge;
          };
        };

        #
        # Bridge config
        #
        "30-${vlan.bridge}" = {
          matchConfig.Name = vlan.bridge;
        };
      }
    ) { } vlans;
  };
}
