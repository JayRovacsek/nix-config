# Shared nixpkgs evaluation config, consumed by every `import nixpkgs` in
# the flake (the per-system pkgs in flake.nix and common/package-sets.nix).
#
# Declaring allowUnfree here — rather than relying on the
# NIXPKGS_ALLOW_UNFREE environment variable — keeps evaluation pure: flakes
# ignore the environment unless --impure is passed, so unfree packages such
# as packages/other/halogen-flash-server would otherwise fail to evaluate.
_: {
  allowUnfree = true;

  permittedInsecurePackages = [ ];
}
