{ self, ... }: {
  imports = [ self.inputs.impermanence.nixosModules.impermanence ];
}
