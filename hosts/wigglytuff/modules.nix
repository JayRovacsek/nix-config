{ config, pkgs, ... }:
let nixConfig = import ../../modules/nix { pkgs = pkgs; };
in {
  nix = nixConfig.nix;
  imports = [
    ../../modules/alacritty
    ../../modules/clamav
    ../../modules/gnupg
    ../../modules/hardware/raspberry-pi-4
    ../../modules/lsd
    ../../modules/networking
    ../../modules/openssh
    ../../modules/starship
    ../../modules/time
    ../../modules/xfce
    ../../modules/zsh
  ];
}
