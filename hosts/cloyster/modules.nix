{ config, pkgs, ... }: {
  imports = [
    ../../modules/documentation
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/homebrew
    ../../modules/lorri
    ../../modules/networking
    ../../modules/nix
    ../../modules/time
    ../../modules/zsh
  ];
}
