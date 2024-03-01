{ self }:
let inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [ agenix hyprland lorri nix time timesyncd zsh ])
++ [ disable-assertions ]
