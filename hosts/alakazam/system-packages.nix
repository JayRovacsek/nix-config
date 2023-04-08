{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.nur.repos.kira-bruneau) pokemmo-installer;
  inherit (config.flake.inputs.sbomnix.packages.${system}) sbomnix;
in {
  environment.systemPackages = with pkgs; [
    # CLI
    curl
    vim
    wget
    agenix

    # NUR Packages
    pokemmo-installer

    # TEMP
    sbomnix
  ];
}
