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
  lidarr
  lorri
  microvm.nixosModules.host
  microvm-host
  nginx
  nix
  nix-serve
  nvidia
  openssh
  openvscode-server
  portainer
  radarr
  samba
  sonarr
  sudo
  systemd-networkd
  time
  timesyncd
  udev
  zfs
  zsh
]
