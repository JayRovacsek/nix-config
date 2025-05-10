{
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [ self.inputs.nix-monitored.nixosModules.default ];

  nix = {
    monitored.enable = true;
    package = lib.mkForce pkgs.nix-monitored;
  };
}
