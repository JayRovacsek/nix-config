{ self }:
let inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [ hyprland lorri nix pipewire time timesyncd zsh ])
++ [ disable-assertions ]
