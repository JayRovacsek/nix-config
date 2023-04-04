{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.packages.${system}) trdsql-bin;
in { environment.systemPackages = (with pkgs; [ agenix ]) ++ [ trdsql-bin ]; }
