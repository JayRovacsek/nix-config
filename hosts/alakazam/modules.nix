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
  # TODO: figure the DNS issues that mean local addresses defined in blocky aren't resolved correctly
  # tailscale
  time
  timesyncd
  udev
  zsh
]

