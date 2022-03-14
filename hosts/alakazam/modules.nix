{ config, pkgs, ... }:
let nixConfig = import ../../modules/nix { pkgs = pkgs; };
in {
  nix = nixConfig.nix;
  imports = [
    ../../modules/alacritty
    ../../modules/clamav
    ../../modules/docker
    ../../modules/firefox
    ../../modules/fonts
    ../../modules/gnome
    ../../modules/gnupg
    ../../modules/lorri
    ../../modules/lsd
    ../../modules/networking
    ../../modules/nvidia
    ../../modules/openssh
    ../../modules/pipewire
    ../../modules/starship
    ../../modules/rofi
    ../../modules/steam
    ../../modules/time
    ../../modules/udev
    ../../modules/vscode
    ../../modules/zsh
  ];
}
