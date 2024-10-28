{ self, ... }:
let
  inherit (self.inputs.nixpkgs) lib;
  secrets-folders = builtins.attrNames (
    lib.filterAttrs (_: v: v == "directory") (builtins.readDir ./.)
  );
in

builtins.foldl' (
  accumulator: folder:
  {
    ${folder} = import ./${folder};
  }
  // accumulator
) { } secrets-folders
