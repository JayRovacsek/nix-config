{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    exfat
    cifs-utils
    dnsutils
    zfs
    pciutils
    nvidia-docker
    lm_sensors
    hddtemp
  ];
}
