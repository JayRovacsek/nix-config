{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs) lib;
    inherit (pkgs.stdenv) isLinux;
    inherit (self.inputs) hyprland;
  in { imports = lib.optional isLinux hyprland.nixosModules.default; })
package-sets