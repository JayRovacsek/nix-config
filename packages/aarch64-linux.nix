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
    nixfmt

    # Browsers
    ungoogled-chromium
    
    # Productivity
    keepassxc 
    nextcloud-client 
  ];
}
