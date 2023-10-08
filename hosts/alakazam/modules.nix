{ self }:
with self.nixosModules; [
  agenix
  clamav
  docker
  fonts
  generations
  gnupg
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
  time
  timesyncd
  udev
  zsh
]

