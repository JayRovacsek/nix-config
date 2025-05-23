{
  self,
  ...
}:
{
  imports = with self.inputs; [
    nixos-hardware.nixosModules.raspberry-pi-5
    raspberry-pi-nix.nixosModules.raspberry-pi
    self.nixosModules.minimal-boot-filesystems
  ];

  raspberry-pi-nix.board = "bcm2712";
}
