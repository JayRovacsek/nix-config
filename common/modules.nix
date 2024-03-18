{ self }:
let
  inherit (self.common)
    age fonts generations gids home-manager impermanence i18n options
    package-sets stylix standardise-nix uids;
  inherit (self.inputs.nur.nixosModules) nur;
in builtins.mapAttrs (package-set: _:
  home-manager.${package-set} ++ [
    age
    fonts
    generations.${package-set}
    gids
    i18n.${package-set}
    impermanence.${package-set}
    nur
    options.${package-set}
    standardise-nix.${package-set}
    stylix.${package-set}
    uids
  ]) package-sets
