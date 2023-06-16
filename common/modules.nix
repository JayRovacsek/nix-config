{ self }:
let
  inherit (self.common)
    age home-manager hyprland impermanence i18n nixified-ai options package-sets
    self-reference stylix standardise-nix;
  inherit (self.inputs.nur.nixosModules) nur;
in builtins.mapAttrs (package-set: _:
  home-manager.${package-set} ++ [
    age
    hyprland.${package-set}
    i18n.${package-set}
    impermanence.${package-set}
    nixified-ai.${package-set}
    nur
    options.${package-set}
    self-reference
    standardise-nix.${package-set}
    stylix.${package-set}
  ]) package-sets
