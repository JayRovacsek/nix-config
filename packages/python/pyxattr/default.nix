{ attr, stdenv, lib, python3Packages, ... }:
python3Packages.pyxattr.overrideAttrs (old: rec {
  buildInputs = lib.optionals stdenv.isLinux attr;

  meta = lib.recursiveUpdate old.meta {
    platforms = old.meta.platforms ++ [ "aarch64-darwin" "x86_64-darwin" ];
  };

  hardeningDisable = lib.optionals stdenv.isDarwin [ "strictoverflow" ];
})
