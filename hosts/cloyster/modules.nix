{ self }:
let inherit (self.inputs.nixos-hardware.nixosModules) apple-t2;
in (with self.nixosModules; [
  agenix
  clamav
  fonts
  gnupg
  greetd
  hyprland
  lorri
  nix
  openssh
  steam
  systemd-networkd
  time
  timesyncd
  udev
  zsh
]) ++ [ apple-t2 ]

