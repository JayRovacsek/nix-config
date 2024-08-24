{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (lib.lists) intersectLists drop take;
in
lists:
# CURRENTLY BROKEN
# TODO: resolve
if ((builtins.length lists) > 2) then
  self.lib.intersect-multiple-lists (intersectLists (take 2 lists)) (drop 2 lists)
else
  intersectLists lists
