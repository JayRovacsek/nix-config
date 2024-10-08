{ self }:
let
  inherit (self.common.system) unstable-system;
  inherit (self.common.package-sets) x86_64-linux-unstable;
  inherit (self.nixosModules) amazon-image zsh;

  inherit (x86_64-linux-unstable) system identifier pkgs;
  base = self.common.modules.${identifier};
  modules = base ++ [
    ../../hosts/ditto
    amazon-image
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
