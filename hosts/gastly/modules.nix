{ self }:
with self.nixosModules; [
  agenix
  clamav
  fonts
  gnupg
  greetd
  grub
  hyprland
  lorri
  nix
  openssh
  steam
  systemd-networkd
  time
  timesyncd
  udev
  zsh
]
