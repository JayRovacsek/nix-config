{
  self,
  ...
}:
{
  imports = [
    self.inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base
    self.nixosModules.minimal-boot-filesystems
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
}
