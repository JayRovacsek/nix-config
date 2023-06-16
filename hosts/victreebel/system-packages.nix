{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.packages.${system}.goModules) trdsql;
in { environment.systemPackages = (with pkgs; [ agenix ]) ++ [ trdsql ]; }
