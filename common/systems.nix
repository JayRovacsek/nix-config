{ self }:
let
  linux = self.nixosConfigurations;
  darwin = self.darwinConfigurations;
in { inherit linux darwin; }
