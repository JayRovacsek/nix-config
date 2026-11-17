{ self }:
let
  inherit (self.common) package-sets;
in
builtins.mapAttrs (
  packageSet: _:
  let
    pkgs = self.common.package-sets.${packageSet};
    inherit (pkgs) lib;
    inherit (pkgs.stdenv.hostPlatform) isLinux;
  in
  {
    imports = lib.optionals isLinux [ ../modules/generations ];
  }
) package-sets
