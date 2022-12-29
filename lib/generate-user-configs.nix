{ self }:

let
  fn = { flake, pkgs, users }:
    with builtins;
    let
      inherit (self.lib) generate-user-config;
      inherit (pkgs.lib.attrsets) recursiveUpdate;
      result = foldl' recursiveUpdate { }
        (map (user: generate-user-config { inherit flake pkgs user; }) users);
    in result;
in fn
