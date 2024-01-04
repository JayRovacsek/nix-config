{ self }:
let
  inherit (self.common) age options package-sets self-reference standardise-nix;
  inherit (self.inputs.nur.nixosModules) nur;
in builtins.mapAttrs (package-set: _: [
  age
  options.${package-set}
  self-reference
  standardise-nix.${package-set}
]) package-sets
