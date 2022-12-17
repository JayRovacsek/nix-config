{ self }:

let
  map-user-function = { config, pkgs, users, extraModules }:
    with builtins;
    let
      inherit (self.lib) generate-user-config;
      inherit (pkgs.lib.attrsets) recursiveUpdate;
      result = foldl' (x: y: recursiveUpdate x y) (map
        (x: generate-user-config { inherit config pkgs user extraModules; })
        users);
    in result;
in map-user-function
