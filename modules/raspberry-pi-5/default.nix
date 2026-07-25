{
  self,
  ...
}:
{
  imports = [
    self.inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    self.nixosModules.minimal-boot-filesystems
  ];

  boot.loader.raspberry-pi.bootloader = "kernel";
}
