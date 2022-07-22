{ config, pkgs, lib, flake, ... }:
let mode = "dns-server";
in {
  imports = [
    ../../modules/agenix
    ../../modules/fonts
    ../../modules/gnupg
    (import ../../modules/hardware/raspberry-pi-3b-plus { inherit pkgs; })
    ../../modules/lorri
    ../../modules/networking
    (import ../../modules/nix {
      inherit config flake;
      arch = "aarch64-linux";
    })
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    ../../modules/starship
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/zsh
  ];
}
