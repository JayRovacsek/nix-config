{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) base;
in base
++ (with home-manager-modules; [ bat direnv fzf git jq lsd man starship zsh ])
