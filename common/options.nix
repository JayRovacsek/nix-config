{ self, package-set }:
let
  # TODO: rewrite this to expose per system rather than the below hack.
  pkgs = self.common.package-sets.${package-set};
  inherit (pkgs.stdenv) isLinux isDarwin;
  generic = [ ../options/flake ../options/hardware ../options/networking ];
  linux = if isLinux then [ ../options/systemd ../options/tailscale ] else [ ];
  darwin = if isDarwin then [ ] else [ ];
  imports = generic ++ linux ++ darwin;
in { inherit imports; }
