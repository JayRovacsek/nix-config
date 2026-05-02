{ self, ... }:
let
  party = [ ];
in
{
  microvm = {
    macvlans = builtins.map (
      vlan: vlan // { parent = "10-wired"; }
    ) self.common.config.networks;

    vms = builtins.foldl' (
      acc: host:
      acc
      // {
        ${host} = {
          config =
            { ... }:
            {
              imports = [ (./. + "/../${host}") ];
            };

          specialArgs = {
            inherit self;
            microvm = true;
          };
        };
      }
    ) { } party;
  };
}
