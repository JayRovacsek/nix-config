{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    vim
    wget

    # Yubikey
    libfido2

    # System Notifications
    libnotify
  ];
}
