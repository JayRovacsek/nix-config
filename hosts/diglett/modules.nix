{ self }:
let inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [
  clamav
  gnupg
  linode-image
  lorri
  nix
  openssh
  time
  timesyncd
  zsh
]) ++ [ disable-assertions ]
