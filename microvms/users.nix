{ config }:
let
  users =
    builtins.map (x: import ../../users/standard/${x}.nix { inherit config; })
    [ "jay" ];
in users
