{ self }:
let inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [
  clamav
  gnupg
  lorri
  nix
  openssh
  time
  timesyncd
  zsh
]) ++ [ disable-assertions ]
