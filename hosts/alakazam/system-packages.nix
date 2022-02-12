{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    vim
    wget

    # Yubikey
    libfido2

    # Nvidia
    linuxPackages.nvidia_x11

    # System Notifications
    libnotify
  ];
}
