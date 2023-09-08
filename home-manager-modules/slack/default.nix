{ pkgs, lib, osConfig, ... }:
let
  # TODO: rewrite this garbage
  enable = !(lib.hasInfix "aarch" osConfig.nixpkgs.system);

  packages = lib.optional enable (with pkgs; [ slack ]);
in { home = { inherit packages; }; }
