{
  self,
  ...
}:
{
  imports = [
    self.nixosModules.minimal-boot-filesystems
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
}
