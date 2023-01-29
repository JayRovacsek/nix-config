{ self }:
let inherit (self.inputs) agenix agenix-darwin;
in {
  linux = agenix.nixosModule;
  darwin = agenix-darwin.nixosModules.age;
}
