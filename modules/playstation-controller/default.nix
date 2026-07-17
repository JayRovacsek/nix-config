{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    dualsensectl
  ];

  services.udev.extraRules = ''
    # Gaming peripherals
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="input"

    # PS4 DualShock
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0664", GROUP="input", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0664", GROUP="input", TAG+="uaccess"
  '';
}
