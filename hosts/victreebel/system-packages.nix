{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.packages.${system}.go-packages) trdsql;
in { environment.systemPackages = (with pkgs; [ agenix ]) ++ [ trdsql ]; }
