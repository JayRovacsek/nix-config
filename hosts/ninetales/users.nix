{ config, pkgs, ... }:
let
  inherit (pkgs) lib;
  users = builtins.map
    (x: import ../../users/standard/${x}.nix { inherit config pkgs; })
    [ "jay-darwin" ];
in users
