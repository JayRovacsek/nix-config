{ self, system }:
let
  inherit (self.lib) merge;

  nixinate = import ./nixinate.nix { inherit self system; };
  terraform = import ./terraform.nix { inherit self system; };

in merge [ nixinate terraform ]
