_: {
  boot.loader = {
    systemd-boot.configurationLimit = 10;
    raspberryPi.uboot.configurationLimit = 20;
    grub.configurationLimit = 25;
    generic-extlinux-compatible.configurationLimit = 20;
  };
}

