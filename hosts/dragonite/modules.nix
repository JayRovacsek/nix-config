{ self }:
with self.nixosModules; [
  agenix
  blocky
  clamav
  docker
  fonts
  gnupg
  hydra
  headscale
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
  zfs
  zsh
]
