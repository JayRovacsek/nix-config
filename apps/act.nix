{ pkgs, ... }:
let
  inherit (pkgs) act;

  args = [ "-P ubuntu-latest=alpine:latest" "-j validate-nix" ];

  program = builtins.toString (pkgs.writers.writeBash "run-act" ''
    ${act}/bin/act ${builtins.concatStringsSep " " args}
  '');

  type = "app";

in { act-local = { inherit program type; }; }
