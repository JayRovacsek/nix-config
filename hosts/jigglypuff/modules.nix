{ self }:
(with self.nixosModules; [
  agenix
  blocky
  fonts
  gnupg
  journald
  lorri
  nix
  openssh
  sudo
  systemd-networkd
  # Disabled while I dig into issues around this
  # plus blocky on the localhost
  # tailscale
  time
  timesyncd
  zsh
]) ++ [
  "${self.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
]
