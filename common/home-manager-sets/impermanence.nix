{ self }:
let inherit (self.common) home-manager-modules;
in (with home-manager-modules; [ impermanence ]) ++ [{
  imports = [ self.inputs.impermanence.nixosModules.home-manager.impermanence ];
}]
