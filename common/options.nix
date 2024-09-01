{ self }:
let
  inherit (self.common) package-sets;
in
builtins.mapAttrs (
  package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs.lib) filterAttrs hasSuffix optionals;
    inherit (pkgs.stdenv) isLinux isDarwin;

    darwin = optionals isDarwin [
      ../options/modules/blocky-darwin
      ../options/modules/docker-darwin
      ../options/modules/dockutil
      ../options/modules/networking-darwin
      ../options/modules/ssh-darwin
      ../options/modules/systemd-darwin
    ];

    generic = [
      ../options/modules/hardware
      ../options/modules/networking
      ../options/modules/nix
    ];

    linux = optionals isLinux [ ../options/modules/systemd ];

    is-system-appropriate =
      isLinux: isDarwin: n:
      if isLinux && hasSuffix "darwin" n then
        false
      else if isDarwin && hasSuffix "linux" n then
        false
      else
        true;

    # For all directories within the options folder,
    # assume they include a default.nix and load that
    all-modules = {
      imports = builtins.map (v: ../options/modules/${v}) (
        builtins.attrNames (
          filterAttrs (
            n: v: v == "directory" && (is-system-appropriate isLinux isDarwin n)
          ) (builtins.readDir ../options/modules)
        )
      );
    };

    all-home-manager-modules = {
      imports = builtins.map (v: ../options/home-manager-modules/${v}) (
        builtins.attrNames (
          filterAttrs (
            n: v: v == "directory" && (is-system-appropriate isLinux isDarwin n)
          ) (builtins.readDir ../options/home-manager-modules)
        )
      );
    };

    minimal = {
      imports = darwin ++ generic ++ linux;
    };
  in
  {
    inherit all-home-manager-modules all-modules minimal;
  }
) package-sets
