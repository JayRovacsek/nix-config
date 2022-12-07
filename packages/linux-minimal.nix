{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI Utilities
    git
    htop
    killall
  ];
}
