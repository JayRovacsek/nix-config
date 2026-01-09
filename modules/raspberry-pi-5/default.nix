{
  self,
  ...
}:
{
  imports = with self.inputs; [
    nixos-hardware.nixosModules.raspberry-pi-5
    self.nixosModules.minimal-boot-filesystems
  ];
}
