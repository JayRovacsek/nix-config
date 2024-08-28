{ self }:
let
  inherit (self.common) package-sets;
in
builtins.mapAttrs (
  package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs.lib) filterAttrs optionals;
    inherit (pkgs.stdenv) isLinux isDarwin;

    darwin = optionals isDarwin [
      ../options/blocky
      ../options/darwin-systemd
      ../options/docker-darwin
      ../options/dockutil
      ../options/networking-darwin
      ../options/ssh-darwin
    ];

    generic = [
      ../options/hardware
      ../options/networking
      ../options/nix
    ];

    linux = optionals isLinux [ ../options/systemd ];

    # For all directories within the options folder,
    # assume they include a default.nix and load that
    all = {
      imports = builtins.map (v: ../options/${v}) (
        builtins.attrNames (
          filterAttrs (_: v: v == "directory") (builtins.readDir ../options)
        )
      );
    };

    minimal = {
      imports = darwin ++ generic ++ linux;
    };
  in
  {
    inherit all minimal;
  }
) package-sets
