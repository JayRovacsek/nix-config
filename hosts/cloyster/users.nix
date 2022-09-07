{ config, pkgs, ... }:
let
  users =
    builtins.map (x: import ../../users/standard/${x}.nix) [ "jay-darwin" ];
in users
