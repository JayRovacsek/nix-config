{ self }:
let
  inherit (self.inputs) neovim-flake;
  inherit (self.common) home-manager-modules;
  inherit (self.common.home-manager-module-sets) base;
in base ++ (with home-manager-modules; [
  bat
  direnv
  fzf
  git
  jq
  lsd
  man
  neovim
  nix-index
  starship
  zsh
]) ++ [ neovim-flake.homeManagerModules.default ]
