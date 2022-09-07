{ config, pkgs, lib, flake, ... }: {
  imports = [
    ../../modules/agenix
    ../../modules/clamav
    ../../modules/docker
    ../../modules/fonts
    ../../modules/gnome
    ../../modules/gnupg
    ../../modules/networking
    ../../modules/nix
    ../../modules/openssh
    ../../modules/pipewire
    ../../modules/steam
    (import ../../modules/tailscale {
      inherit config pkgs lib;
      tailnet = "trust";
    })
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/udev
    ../../modules/zsh
  ];
}
