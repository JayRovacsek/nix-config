{ pkgs, ... }:
let
  inherit (pkgs) act;

  cfg = pkgs.writeText "flatpak-shim-info" config;

  config = ''
    -P ubuntu-latest=node:16-buster-slim
    -P ubuntu-22.04=node:16-buster-slim
    -P ubuntu-20.04=node:16-buster-slim
    -P ubuntu-18.04=node:16-buster-slim
  '';

  program = builtins.toString (pkgs.writers.writeBash "run-act" ''
    ${act}/bin/act --env-file ${cfg}
  '');

  type = "app";

in { act-local = { inherit program type; }; }
