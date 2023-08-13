{ lib, osConfig, ... }:
let
  inherit (lib.strings) hasInfix;
  isLinux = hasInfix "linux" osConfig.nixpkgs.system;

  cfg = lib.optionalAttrs isLinux {
    programs.fuzzel = {
      enable = true;
      settings = {

      };
    };
  };
in cfg
