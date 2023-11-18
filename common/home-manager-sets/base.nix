{ self }:
let inherit (self.common) home-manager-modules;
in (with home-manager-modules; [ home-manager impermanence xdg ])
++ [ self.inputs.impermanence.nixosModules.home-manager.impermanence ]
