{ config, pkgs, lib, flake, ... }:
let mode = "dns-server";
in {
  imports = [
    ../../modules/agenix
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/journald
    ../../modules/hardware/raspberry-pi-3b-plus
    ../../modules/lorri
    ../../modules/networking
    ../../modules/nix
    ../../modules/openssh
    ../../modules/raspberry-pi/${mode}.nix
    (import ../../modules/tailscale {
      inherit config pkgs lib;
      tailnet = "dns";
    })
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/zsh
  ];
}
