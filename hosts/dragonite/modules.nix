{ self }:
let inherit (self.inputs) microvm;
in with self.nixosModules; [
  # loki
  # grafana
  # grafana-agent
  # telegraf

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
  microvm.nixosModules.host
  microvm-host
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
