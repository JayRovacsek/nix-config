{ self }:
let inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [
  agenix
  hyprland
  lorri
  nix
  pipewire
  time
  timesyncd
  zsh
]) ++ [ disable-assertions ]
