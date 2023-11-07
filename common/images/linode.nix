{ self }:
let
  inherit (self.common.system) unstable-system;
  inherit (self.common.assertions) disable-assertions;
  inherit (self.nixosModules) linode-image zsh;
  inherit (self.common.package-sets) x86_64-linux-unstable;

  inherit (x86_64-linux-unstable) system identifier pkgs;
  base = self.common.modules.${identifier};
  modules = base ++ [ ../../hosts/ditto disable-assertions linode-image zsh ];

in unstable-system { inherit system pkgs modules; }
