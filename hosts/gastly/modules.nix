{ self }:
with self.nixosModules; [
  agenix
  clamav
  docker
  fonts
  gdm
  gnome
  gnupg
  grub
  lorri
  nix
  openssh
  pipewire
  steam
  systemd-networkd
  time
  timesyncd
  udev
  zsh
]
