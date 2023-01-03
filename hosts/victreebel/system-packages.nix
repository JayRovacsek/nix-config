{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.recursive.flake.outputs.packages.${system}) amethyst;
in { environment.systemPackages = with pkgs; [ agenix amethyst ]; }
