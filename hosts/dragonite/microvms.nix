{ self, ... }:
let
  party = [
    "bellsprout"
    "igglybuff"
    "machop"
    "magikarp"
    "mankey"
    "meowth"
    "mr-mime"
    "nidoking"
    "nidorina"
    "nidorino"
    "poliwag"
    "slowpoke"
  ];
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
