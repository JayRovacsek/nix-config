{ self }:
let
  inherit (self.lib) standardise-nix;
  inherit (self.common) package-sets home-manager self-reference options;
in builtins.mapAttrs
(package-set: _: home-manager.${package-set} ++ [ options self-reference ])
package-sets
