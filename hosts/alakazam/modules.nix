{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/agenix
    ../../modules/clamav
    ../../modules/docker
    ../../modules/fonts
    ../../modules/gnome
    ../../modules/gnupg
    ../../modules/lorri
    ../../modules/nix
    ../../modules/microvm/host
    ../../modules/nvidia
    ../../modules/openssh
    ../../modules/pipewire
    ../../modules/steam
    ../../modules/tailscale
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/udev
    ../../modules/zsh
  ];
}
