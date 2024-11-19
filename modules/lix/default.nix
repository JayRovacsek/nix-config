{ self, ... }:
{
  imports = [ self.inputs.lix-module.nixosModules.lixFromNixpkgs ];
}
