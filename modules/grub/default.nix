_: {
  # This is only suitable for encrypted device configurations.
  # to use it outside of those settings we intentionally want
  # to introduce pain in the process
  boot.loader.grub = {
    enable = true;
    # Needs to be changed if not utilising encrypted disks
    device = "nodev";
    efiSupport = true;
    # Needs to be changed if not utilising encrypted disks
    enableCryptodisk = true;
  };
}
