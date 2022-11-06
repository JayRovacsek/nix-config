{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.unstablePackages.${system}) pokemmo-installer;
in {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    vim
    wget
    agenix
    # pokemmo
    pokemmo-installer
  ];
}
