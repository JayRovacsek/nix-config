{ self }:
let
  inherit (self.common) home-manager-modules;
  inherit (self.inputs.stylix.homeManagerModules) stylix;
in with home-manager-modules; [
  alacritty
  bat
  dircolours
  direnv
  fzf
  git
  jq
  lsd
  man
  starship
  stylix
  zsh
]
