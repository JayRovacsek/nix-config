{ self }:
let
  inherit (self.common) options package-sets standardise-nix;
in
builtins.mapAttrs (package-set: _: [
  options.${package-set}.minimal
  standardise-nix.${package-set}
]) package-sets
