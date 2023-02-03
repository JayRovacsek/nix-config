{ self }:
let
  inherit (self.common)
    age home-manager nur options package-sets self-reference standardise-nix;
in builtins.mapAttrs (package-set: _:
  home-manager.${package-set} ++ [
    age
    nur
    options.${package-set}
    self-reference
    standardise-nix.${package-set}
  ]) package-sets
