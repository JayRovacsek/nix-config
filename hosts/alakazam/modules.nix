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
  impermanence
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

