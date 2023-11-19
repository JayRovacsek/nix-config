{ self }:
let inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [
  amazon-image
  clamav
  gnupg
  lorri
  nix
  openssh
  ssm
  time
  timesyncd
  zsh
]) ++ [ disable-assertions ]
