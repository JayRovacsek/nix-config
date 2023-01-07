{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.outputs.packages.${system}) amethyst;
in { environment.systemPackages = with pkgs; [ agenix amethyst ]; }
