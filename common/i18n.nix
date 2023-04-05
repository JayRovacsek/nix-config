{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs.stdenv) isLinux isDarwin;
    linux = if isLinux then [ ../modules/i18n ] else [ ];
    darwin = if isDarwin then [ ] else [ ];
    imports = linux ++ darwin;
  in { inherit imports; }) package-sets
