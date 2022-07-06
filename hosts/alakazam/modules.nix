{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/agenix
    ../../modules/clamav
    ../../modules/docker
    ../../modules/fonts
    ../../modules/gnome
    ../../modules/gnupg
    ../../modules/lorri
    ../../modules/systemd-networkd
    ../../modules/nix
    ../../modules/nvidia
    ../../modules/openssh
    ../../modules/pipewire
    ../../modules/starship
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
