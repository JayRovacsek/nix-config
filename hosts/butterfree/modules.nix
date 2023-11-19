{ self }:
let
  inherit (self.common.images.configurations) amazon;
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
]) ++ [ amazon._module.args.modules disable-assertions ]
