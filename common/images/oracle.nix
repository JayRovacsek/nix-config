{ self }:
let
  inherit (self.common.system) unstable-system;
  inherit (self.nixosModules) disable-assertions oracle-image zsh;
  inherit (self.common.package-sets) x86_64-linux-unstable;

  inherit (x86_64-linux-unstable) system identifier pkgs;
  base = self.common.modules.${identifier};
  modules = base ++ [
    ../../hosts/ditto
    disable-assertions
    oracle-image
    zsh
  ];
  specialArgs = {
    inherit self;
  };

in
unstable-system {
  inherit
    system
    pkgs
    modules
    specialArgs
    ;
}
