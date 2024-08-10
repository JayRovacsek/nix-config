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
    ) self.common.networking.networks;

    vms = builtins.foldl' (
      acc: host:
      acc
      // {
        ${host} = {
          specialArgs = {
            inherit self;
            microvm = true;
          };
          config =
            { ... }:
            {
              imports = [ (./. + "/../${host}") ];
            };
        };
      }
    ) { } party;
  };
}
