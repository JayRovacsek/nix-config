{
  imports = [
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
    # Disable until I can deploy headscale to server
    # ../../modules/tailscale
    ../../modules/time
    ../../modules/timesyncd
    ../../modules/udev
    ../../modules/zsh
  ];
}
