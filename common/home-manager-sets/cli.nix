{ self }:
let
  inherit (self.inputs) nixvim;
  inherit (self.common.home-manager-module-sets) base;
in
base
++ (with self.homeManagerModules; [
  agenix
  atuin
  bat
  difftastic
  direnv
  fzf
  git
  jq
  lsd
  man
  neovim
  starship
  zsh
])
++ [ nixvim.homeModules.nixvim ]
