{ self }:
let
  inherit (self.common) age gids options package-sets standardise-nix uids;
  inherit (self.inputs.nur.nixosModules) nur;
in builtins.mapAttrs (package-set: _: [
  age
  gids
  options.${package-set}
  standardise-nix.${package-set}
  uids
]) package-sets
