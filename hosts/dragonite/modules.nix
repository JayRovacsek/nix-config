{
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
    ../../modules/nix
    ../../modules/nix-serve
    ../../modules/nvidia
    ../../modules/openssh
    (import ../../modules/tailscale {
      inherit config pkgs lib;
      tailnet = "trust";
    })
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/udev
    ../../modules/zfs
    ../../modules/zsh
    ./old-users.nix
    ./filesystems.nix
  ];
}
