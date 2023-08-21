{ self, system }:
let
  pkgs = import self.inputs.nixpkgs { inherit system; };
  inherit (pkgs) nixci;

  program = builtins.toString (pkgs.writers.writeBash "run-nixci" ''
    ${nixci}/bin/nixci
  '');

  type = "app";

in { nixci-run = { inherit program type; }; }
