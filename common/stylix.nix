{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs) lib;
    inherit (pkgs.stdenv) isLinux isDarwin;
    inherit (self.inputs) stylix;

    darwin-modules = lib.optional isDarwin stylix.darwinModules.stylix;
    linux-modules = lib.optional isLinux stylix.nixosModules.stylix;
  in { imports = darwin-modules ++ linux-modules; }) package-sets
