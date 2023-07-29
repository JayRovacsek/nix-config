{ self }:
with self.nixosModules; [
  agenix
  clamav
  docker
  fonts
  generations
  gnome
  gnupg
  hyprland
  keybase
  lorri
  nextcloud-client
  nix
  nixinate
  nvidia
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

