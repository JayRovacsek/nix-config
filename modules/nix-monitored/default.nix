{ self, ... }: {
  imports = [ self.inputs.nix-monitored.nixosModules.default ];

  nix.monitored.enable = true;
}
