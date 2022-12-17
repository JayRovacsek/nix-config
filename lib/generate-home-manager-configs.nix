{ self }:
let
  map-modules-function = { config, pkgs, modules }:
    with builtins;
    let
      inherit (self.lib) generate-home-manager-config;
      inherit (pkgs.lib.attrsets) recursiveUpdate;
      result = foldl' (x: y: recursiveUpdate x y)
        (map (x: generate-home-manager-config { inherit config pkgs; }) users);
    in result;
in map-modules-function
