{ self }:
with self.nixosModules; [
  acme
  authelia
  agenix
  blocky
  clamav
  ddclient
  docker
  fonts
  gnupg
  headscale
  hydra
  jellyfin
  jellyseerr
  lidarr
  lorri
  nginx
  nix
  nix-serve
  nvidia
  openssh
  portainer
  prowlarr
  radarr
  samba
  sonarr
  sudo
  tailscale
  time
  timesyncd
  udev
  zfs
  zsh
]
