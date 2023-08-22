{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.packages.${system}) trdsql;
in {
  environment.systemPackages = (with pkgs; [ curl wget agenix ]) ++ [ trdsql ];
}
