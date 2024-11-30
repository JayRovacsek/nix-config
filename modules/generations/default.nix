_: {
  boot.loader = {
    systemd-boot.configurationLimit = 10;
    grub.configurationLimit = 25;
    generic-extlinux-compatible.configurationLimit = 20;
  };
}
