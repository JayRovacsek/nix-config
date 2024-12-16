{
  lib,
  ...
}:
{
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
}
