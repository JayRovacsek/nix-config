{
  self,
  ...
}:
{
  imports = with self.inputs; [
    nixos-hardware.nixosModules.raspberry-pi-5
    self.nixosModules.minimal-boot-filesystems
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
}
