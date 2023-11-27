{ self }:
let inherit (self.common) package-sets;
in builtins.mapAttrs (package-set: _:
  let
    pkgs = self.common.package-sets.${package-set};
    inherit (pkgs.lib.lists) optionals;
    inherit (pkgs.stdenv) isLinux isDarwin;

    generic = [
      ../options/flake
      ../options/hardware
      ../options/networking
      ../options/nix
    ];

    linux = optionals isLinux [
      ../options/headscale
      ../options/jellyfin
      ../options/sonarr
      ../options/systemd
      ../options/tailscale
    ];

    darwin = optionals isDarwin [
      ../options/blocky
      ../options/docker
      ../options/dockutil
      ../options/networking/darwin.nix
      ../options/ssh
    ];

    imports = generic ++ linux ++ darwin;
  in { inherit imports; }) package-sets
