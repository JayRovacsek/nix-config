{ self }:
let
  inherit (self.common)
    home-manager
    options
    package-sets
    stylix
    standardise-nix
    ;
  inherit (self.inputs.nur.nixosModules) nur;
in
builtins.mapAttrs (
  package-set: _:
  home-manager.${package-set}
  ++ [
    nur
    options.${package-set}.minimal
    standardise-nix.${package-set}
    stylix.${package-set}
  ]
) package-sets
