{ config, pkgs, lib, flake, ... }:
let mode = "desktop";
in {
  imports = [
    ../../modules/agenix
    ../../modules/clamav
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/hardware/raspberry-pi-4
    ../../modules/lorri
    ../../modules/networking
    (import ../../modules/nix {
      inherit config flake;
      arch = "aarch64-linux";
    })
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    ../../modules/time
    ../../modules/zsh
  ];
}
