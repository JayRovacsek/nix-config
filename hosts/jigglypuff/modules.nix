{ config, pkgs, lib, flake, ... }:
let mode = "dns-server";
in {
  imports = [
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/lorri
    ../../modules/networking
    (import ../../modules/nix { inherit config pkgs flake; })
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    ../../modules/starship
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/zsh
  ];
}
