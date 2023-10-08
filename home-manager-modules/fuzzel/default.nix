{ lib, osConfig, ... }:
let
  inherit (lib) hasInfix;
  isLinux = hasInfix "linux" osConfig.nixpkgs.system;

  cfg = lib.optionalAttrs isLinux {
    programs.fuzzel = {
      enable = true;
      settings.main = {
        vertical-pad = 50;
        horizontal-pad = 100;
        show-actions = "yes";
        lines = 20;
        width = 80;
      };
    };
  };
in cfg
