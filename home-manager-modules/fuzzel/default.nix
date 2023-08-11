{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = lib.optionalAttrs isLinux {
    programs.fuzzel = {
      enable = true;
      settings = {

      };
    };
  };
in cfg
