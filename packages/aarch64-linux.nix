{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    git
    htop
    jq
    killall
    lsd
    tree
    unzip

    # Development
    nixfmt

    # Browsers
    ungoogled-chromium

    # Productivity
    keepassxc
    nextcloud-client
  ];
}
