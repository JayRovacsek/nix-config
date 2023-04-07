{ self }:
let
  inherit (self.common)
    age home-manager hyprland i18n options package-sets self-reference
    standardise-nix;
  inherit (self.inputs.nur.nixosModules) nur;
in builtins.mapAttrs (package-set: _:
  home-manager.${package-set} ++ [
    age
    hyprland.${package-set}
    i18n.${package-set}
    nur
    options.${package-set}
    self-reference
    standardise-nix.${package-set}
  ]) package-sets
