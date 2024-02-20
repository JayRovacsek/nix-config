{ self }:
let inherit (self.inputs) microvm;
in with self.nixosModules; [
  agenix
  blocky
  clamav
  firefox-syncserver
  fonts
  gnupg
  hydra
  jellyfin
  jellyseerr
  lorri
  microvm-host
  microvm.nixosModules.host
  nix
  nix-serve
  nvidia
  openssh
  openvscode-server
  samba
  sudo
  systemd-networkd
  time
  timesyncd
  udev
  zfs
  zsh
]
