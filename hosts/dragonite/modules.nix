{ self }:
let inherit (self.inputs) microvm;
in with self.nixosModules; [
  acme
  agenix
  authelia
  blocky
  clamav
  ddclient
  docker
  firefox-syncserver
  fonts
  gnupg
  hydra
  jellyfin
  jellyseerr
  lorri
  microvm-host
  microvm.nixosModules.host
  nginx
  nix
  nix-serve
  nvidia
  openssh
  openvscode-server
  portainer
  samba
  sudo
  systemd-networkd
  time
  timesyncd
  udev
  zfs
  zsh
]
