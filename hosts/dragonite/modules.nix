{ config, pkgs, lib, flake, ... }: {
  imports = [
    ../../modules/agenix
    ../../modules/clamav
    ../../modules/docker
    ../../modules/docker/stacks/portainer
    ../../modules/fonts
    ../../modules/gnupg
    ../../modules/headscale
    ../../modules/libvirtd
    ../../modules/lorri
    # (import ../../modules/microvm/host { inherit config flake lib; })
    ../../modules/nix
    ../../modules/nix-serve
    # ../../modules/nginx
    ../../modules/nvidia
    ../../modules/openssh
    ../../modules/tailscale
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/udev
    ../../modules/zfs
    ../../modules/zsh
    ./old-users.nix
    ./filesystems.nix
  ];
}
