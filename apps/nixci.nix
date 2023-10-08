{ pkgs, ... }:
let
  inherit (pkgs) nixci;

  program = builtins.toString (pkgs.writers.writeBash "run-nixci" ''
    ${nixci}/bin/nixci
  '');

  type = "app";

in { nixci-run = { inherit program type; }; }
