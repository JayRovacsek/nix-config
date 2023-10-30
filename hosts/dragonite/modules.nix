{ self }:
with self.nixosModules; [
  agenix
  blocky
  clamav
  docker
  portainer
  fonts
  gnupg
  headscale
  lorri
  nix
  nix-serve
  nvidia
  openssh
  samba
  sudo
  tailscale
  time
  timesyncd
  udev
  zfs
  zsh
]
