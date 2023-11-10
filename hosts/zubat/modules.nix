{ self }:
let inherit (self.inputs.nixos-wsl.nixosModules) wsl;
in (with self.nixosModules; [ lorri nix time timesyncd zsh ]) ++ [ wsl ]
