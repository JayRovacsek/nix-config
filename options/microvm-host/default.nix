{ config, lib, ... }:
let
  inherit (lib) mkOption recursiveUpdate types;
  cfg = config.microvm;

  maclvan-entry = {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
      };

      parent = mkOption {
        type = types.str;
        default = "";
      };

      vlan-tag = mkOption {
        type = types.int;
        default = 10;
      };
    };
  };

in
{
  options = {
    microvm.macvlans = mkOption {
      description = ''
        Declarative MacVLAN definitions
      '';
      default = [ ];
      type = types.listOf (types.submodule maclvan-entry);
    };
  };

  config = {
    systemd = {
      network = {
        networks = builtins.foldl' (
          acc: interface:
          (recursiveUpdate acc {
            ${interface.parent}.vlan =
              if builtins.hasAttr "${interface.parent}" acc then
                acc.${interface.parent}.vlan ++ [ interface.name ]
              else
                [ interface.name ];

            "30-${interface.name}" = {
              enable = true;
              inherit (interface) name;
            };
          })
        ) { } cfg.macvlans;

        netdevs = builtins.foldl' (
          acc: interface:
          (recursiveUpdate acc {
            "00-${interface.name}" = {
              netdevConfig = {
                Kind = "vlan";
                Name = interface.name;
              };
              vlanConfig.Id = interface.vlan-tag;
            };
          })
        ) { } cfg.macvlans;
      };
    };
  };
}
