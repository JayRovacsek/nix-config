{ self }:
let
  inherit (self.nixosModules)
    gnome agenix clamav docker fonts generations gnupg hyprland keybase lorri
    nextcloud-client nix nixinate nvidia openssh pipewire sddm steam
    systemd-networkd time timesyncd udev zsh;
in [
  agenix
  clamav
  docker
  fonts
  generations
  gnome
  gnupg
  hyprland
  keybase
  lorri
  nextcloud-client
  nix
  nixinate
  nvidia
  openssh
  pipewire
  sddm
  steam
  systemd-networkd
  time
  timesyncd
  udev
  zsh
]

