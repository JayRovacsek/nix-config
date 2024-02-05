{ self }:
let inherit (self.inputs.nixos-hardware.nixosModules) apple-t2;
in (with self.nixosModules; [
  clamav
  docker
  fonts
  generations
  gnupg
  hyprland
  lorri
  nextcloud-client
  nix
  openssh
  pipewire
  sddm
  steam
  systemd-networkd
  time
  timesyncd
  udev
  zsh
]) ++ [ apple-t2 ]

