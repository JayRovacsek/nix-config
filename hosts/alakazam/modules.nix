{ self }:
let inherit (self.inputs) microvm;
in with self.nixosModules; [
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
  microvm-host
  microvm.nixosModules.host
  nextcloud-client
  nix
  nvidia
  openssh
  pipewire
  sddm
  steam
  systemd-networkd
  # tailscale
  time
  timesyncd
  udev
  zsh
]

