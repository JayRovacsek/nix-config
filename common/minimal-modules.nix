{ self }:
let
  inherit (self.common)
    age gids options package-sets self-reference standardise-nix uids;
  inherit (self.inputs.nur.nixosModules) nur;
in builtins.mapAttrs (package-set: _: [
  age
  gids
  options.${package-set}
  self-reference
  standardise-nix.${package-set}
  uids
]) package-sets
