{ self }:
let
  inherit (self.common) package-sets;
in
builtins.mapAttrs (
  package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs.lib.lists) optionals;
    inherit (pkgs.stdenv) isLinux isDarwin;

    darwin = optionals isDarwin [
      ../options/blocky
      ../options/darwin-systemd
      ../options/docker
      ../options/dockutil
      ../options/networking/darwin.nix
      ../options/ssh
    ];

    generic = [
      ../options/hardware
      ../options/networking
      ../options/nix
    ];

    linux = optionals isLinux [ ../options/systemd ];

    imports = darwin ++ generic ++ linux;
  in
  {
    inherit imports;
  }
) package-sets
