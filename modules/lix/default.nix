{ pkgs, self, ... }:
{
  imports = [ self.inputs.lix-module.nixosModules.default ];

  nix.package = pkgs.lix;
}
