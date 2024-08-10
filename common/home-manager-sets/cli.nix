{ self }:
let
  inherit (self.inputs) nixvim;
  inherit (self.common.home-manager-module-sets) base;
in
base
++ (with self.homeManagerModules; [
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
])
++ [ nixvim.homeManagerModules.nixvim ]
