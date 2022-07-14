{ config, pkgs, lib, flake, ... }:
let mode = "desktop";
in {
  imports = [
    ../../modules/clamav
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/hardware/raspberry-pi-4
    ../../modules/lorri
    ../../modules/networking
    (import ../../modules/nix { inherit config pkgs flake; })
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    ../../modules/time
    ../../modules/zsh
  ];
}
