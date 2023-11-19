{ self }:
let
  inherit (self.common.images.configurations) linode;
  inherit (self.common.assertions) disable-assertions;
in (with self.nixosModules; [
  clamav
  gnupg
  lorri
  nix
  openssh
  time
  timesyncd
  zsh
]) ++ [ linode._module.args.modules disable-assertions ]
