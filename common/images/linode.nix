{ self }:
let
  inherit (self.common.system) unstable-system;
  inherit (self.common.package-sets) x86_64-linux-unstable;

  inherit (x86_64-linux-unstable) system identifier pkgs;
  modules = self.common.modules.${identifier}
    ++ [ ../../hosts/ditto self.nixosModules.linode-image ];
  specialArgs = { inherit self; };

in unstable-system { inherit system pkgs modules specialArgs; }
