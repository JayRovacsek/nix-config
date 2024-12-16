{
  self,
  ...
}:
{
  imports = with self.inputs; [
    raspberry-pi-nix.nixosModules.raspberry-pi
    self.nixosModules.minimal-boot-filesystems
  ];

  raspberry-pi-nix.board = "bcm2711";
}
