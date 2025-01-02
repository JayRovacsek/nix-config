{ self }:
let
  inherit (self.common)
    home-manager
    options
    package-sets
    stylix
    standardise-nix
    ;
in
builtins.mapAttrs (
  package-set: _:
  home-manager.${package-set}
  ++ [
    options.${package-set}.minimal
    self.inputs.nur.modules.nixos.default
    standardise-nix.${package-set}
    stylix.${package-set}
  ]
) package-sets
