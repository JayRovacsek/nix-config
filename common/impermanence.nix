{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs) lib;
    inherit (pkgs.stdenv) isLinux;
    inherit (self.inputs) impermanence;
  in {
    imports = lib.optionals isLinux [ impermanence.nixosModules.impermanence ];
  }) package-sets
