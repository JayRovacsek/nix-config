{ self }:
let
  inherit (self.common)
    package-sets home-manager self-reference nur options standardise-nix;
in builtins.mapAttrs (package-set: _:
  home-manager.${package-set} ++ [
    standardise-nix.${package-set}
    # TODO: rewrite options to build subproperties per supported system
    # rahter than this hack. (options.darwin ... ) etc
    (options { inherit self package-set; })
    nur
    self-reference
  ]) package-sets
