{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    git
    htop
    jq
    killall
    lsd
    starship
    tree
    unzip

    # Development
    vscode

    # Media
    mopidy
    mopidy-mopify
    mopidy-jellyfin
  ];
}
