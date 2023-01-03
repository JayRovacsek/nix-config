{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.recursive.flake.packages.${system}) pokemmo-installer;
in {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    vim
    wget
    # agenix
    pokemmo-installer
  ];
}
