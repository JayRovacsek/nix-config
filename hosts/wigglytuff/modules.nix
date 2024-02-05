{ self }:
let inherit (self.inputs.nixos-hardware.nixosModules) raspberry-pi-4;
in (with self.nixosModules; [
  gnupg
  lorri
  nix
  openssh
  sddm
  sudo
  systemd-networkd
  time
  timesyncd
  xfce
  zsh
]) ++ [ raspberry-pi-4 ]
