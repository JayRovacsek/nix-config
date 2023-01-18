{ self }:
let
  inherit (self.common)
    package-sets home-manager self-reference nur options standardise-nix;
in builtins.mapAttrs (package-set: _:
  home-manager.${package-set}
  ++ [ standardise-nix.${package-set} options nur self-reference ]) package-sets
