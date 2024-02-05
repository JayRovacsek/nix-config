{ self }:
with self.nixosModules; [
  clamav
  docker
  fonts
  gnupg
  grub
  hyprland
  lorri
  nix
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
