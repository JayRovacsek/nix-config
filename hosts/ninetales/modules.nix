{ config, pkgs, ... }:
let nixConfig = import ../../modules/nix { pkgs = pkgs; };
in {
  imports = [
    ../../modules/alacritty
    ../../modules/documentation
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/homebrew
    ../../modules/lorri
    ../../modules/lsd
    ../../modules/networking
    ../../modules/starship
    ../../modules/time
    ../../modules/vscode
    ../../modules/zsh
  ];
}
