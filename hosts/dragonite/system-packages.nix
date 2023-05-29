{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    exfat
    cifs-utils
    dnsutils
    pciutils
    lm_sensors
    hddtemp
  ];
}
