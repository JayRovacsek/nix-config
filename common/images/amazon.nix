{ self }:
let
  inherit (self.common.assertions) disable-assertions;
  inherit (self.common.system) unstable-system;
  inherit (self.common.cloud-base-image-modules) amazon;
  inherit (self.common.package-sets) x86_64-linux-unstable;

  inherit (x86_64-linux-unstable) system identifier pkgs;
  base = self.common.modules.${identifier};
  modules = base ++ [ disable-assertions ../../hosts/ditto amazon ];

in unstable-system { inherit system pkgs modules; }
