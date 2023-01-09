{ self, pkgs ? import <nixpkgs> { } }:
let
  inherit (pkgs.lib) recursiveUpdate;

  non-default = with builtins;
    filter (overlay: overlay != "default") (attrNames self.overlays);
  # I hope my nix is up to scratch, but this folds all other functions in overlays into each other to provide
  # a default overlay that applies all others.
  # If I'm not mistaken this can be broken trivially is an overlay 
  # that lexicographically exists before another has a change to a package
  # that is later changed by another overlay, the later will win out.
  #
  # HERE BE DRAGONS! 
  #
  default = final: prev:
    (builtins.foldl' (accumulator: overlay:
      (recursiveUpdate accumulator self.overlays.${overlay} {
        inherit final prev;
      })) { } non-default);
in {
  inherit default;

  hello = final: prev: {
    hello = prev.hello.overrideAttrs (old: rec {
      pname = "hello";
      version = "9001";

      src = prev.fetchurl {
        url = "mirror://gnu/hello/hello-${version}.tar.gz";
        sha256 = prev.lib.fakeHash;
      };

      doCheck = false;
    });
  };

  hello-unfree = final: prev: {
    hello-unfree = prev.hello-unfree.overrideAttrs (old: rec {
      pname = "hello-unfree";
      version = "9002";
    });
  };

  # Useful for SBCs when they will be missing modules that upstream definitions
  # expect but we won't use; e.g SATA
  makeModulesClosure = final: prev:
    prev.makeModulesClosure (final // { allowMissing = true; });

}
