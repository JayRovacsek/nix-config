{ self }:
let
  inherit (self.common.cloud-base-image-modules) linode;
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
]) ++ [ linode disable-assertions ]
