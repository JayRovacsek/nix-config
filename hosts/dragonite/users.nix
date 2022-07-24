{ config, pkgs, flake ? { } }:
let
  users = builtins.map
    (x: import ../../users/standard/${x}.nix { inherit config pkgs flake; }) [
      "jay"
      "builder"
    ];
in users
