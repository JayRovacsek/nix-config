{ config, pkgs, lib, flake, ... }: {
  imports = [
    ../../modules/agenix
    ../../modules/clamav
    ../../modules/docker
    ../../modules/fonts
    ../../modules/gnome
    ../../modules/gnupg
    ../../modules/lorri
    (import ../../modules/nix { inherit config flake pkgs; })
    (import ../../modules/microvm/host { inherit config flake lib; })
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
