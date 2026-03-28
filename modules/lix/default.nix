{
  self,
  ...
}@args:
{
  imports =
    with self.inputs.lix-module;
    if args._class == "nixos" then
      [ nixosModules.lixFromNixpkgs ]
    else
      [ darwinModules.lixFromNixpkgs ];

  lix.enable = true;
}
