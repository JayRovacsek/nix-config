{
  self,
  ...
}:
{
  imports = [
    self.nixosModules.minimal-boot-filesystems
  ];
}
