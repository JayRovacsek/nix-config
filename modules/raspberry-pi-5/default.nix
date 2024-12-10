{
  lib,
  self,
  ...
}:
{
  imports = with self.inputs; [
    nixos-hardware.nixosModules.raspberry-pi-5
    raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  boot = {
    supportedFilesystems = {
      btrfs = lib.mkForce false;
      cifs = lib.mkForce false;
      ext4 = true;
      f2fs = lib.mkForce false;
      ntfs = lib.mkForce false;
      vfat = true;
      xfs = lib.mkForce false;
      zfs = lib.mkForce false;
    };
  };

  raspberry-pi-nix.board = "bcm2712";
}
