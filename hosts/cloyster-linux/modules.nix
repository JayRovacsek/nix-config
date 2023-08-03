{ self }:
with self.nixosModules; [
  agenix
  clamav
  docker
  fonts
  generations
  gnupg
  hyprland
  lorri
  nextcloud-client
  nix
  nixinate
  openssh
  pipewire
  sddm
  steam
  systemd-networkd
  time
  timesyncd
  udev
  zsh
]

