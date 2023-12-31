{ self }:
with self.nixosModules; [
  agenix
  clamav
  docker
  fonts
  generations
  gnupg
  grub
  hyprland
  keybase
  lorri
  nextcloud-client
  nix
  nvidia
  openssh
  pipewire
  sddm
  steam
  systemd-networkd
  tailscale
  time
  timesyncd
  udev
  zsh
]

