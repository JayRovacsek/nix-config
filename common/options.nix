{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs.lib.lists) optionals;
    inherit (pkgs.stdenv) isLinux isDarwin;

    generic = [ ../options/flake ../options/hardware ../options/networking ];

    linux = optionals isLinux [ ../options/systemd ../options/tailscale ];

    darwin = optionals isDarwin [
      ../options/blocky
      ../options/docker
      ../options/networking/darwin.nix
      ../options/ssh
    ];

    imports = generic ++ linux ++ darwin;
  in { inherit imports; }) package-sets
