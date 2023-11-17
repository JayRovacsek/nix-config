{ self }:
let
  inherit (self.common.cloud-base-image-modules) amazon;
  inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [
  clamav
  gnupg
  lorri
  nix
  openssh
  ssm
  time
  timesyncd
  zsh
]) ++ [ amazon disable-assertions ]
