{ self }:
let inherit (self.common) home-manager-modules;
in with home-manager-modules; [
  alacritty
  bat
  dconf
  dircolours
  direnv
  dwarf-fortress
  emacs
  firefox
  fzf
  git
  jq
  lsd
  man
  rofi
  starship
  vscodium
  zsh
]
