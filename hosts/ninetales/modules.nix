{ self }:
with self.nixosModules; [
  darwin-settings
  docker-darwin
  dockutil
  documentation
  fonts
  gnupg
  lorri
  networking
  nix
  time
  yabai
  zsh
]
