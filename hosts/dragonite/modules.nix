{ self }:
with self.nixosModules; [
  agenix
  auto-upgrade
  blocky
  clamav
  docker
  fonts
  gnupg
  hydra
  jellyfin
  lorri
  nix
  nix-serve
  nvidia
  openssh
  portainer
  samba
  sudo
  tailscale
  time
  timesyncd
  udev
  ups
  zfs
  zsh
]
