{ self, ... }:
{
  imports = [ self.inputs.agenix.nixosModules.default ];
}
