{ self }:
let inherit (self.inputs.nixos-hardware.nixosModules) raspberry-pi-4;
in (with self.nixosModules; [
  agenix
  gnupg
  lorri
  nix
  openssh
  greetd
  hyprland
  sudo
  systemd-networkd
  time
  timesyncd
  zsh
]) ++ [ raspberry-pi-4 ]
