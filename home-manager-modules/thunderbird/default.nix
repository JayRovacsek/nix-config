{ lib, osConfig, ... }:
let
  inherit (lib.strings) hasInfix;
  isLinux = hasInfix "linux" osConfig.nixpkgs.system;

  cfg = lib.optionalAttrs isLinux {
    programs.thunderbird = {
      enable = true;
      profiles.jay = {
        isDefault = true;
        settings = { };
      };
      settings = {
        "general.useragent.override" = "";
        "privacy.donottrackheader.enabled" = true;
      };
    };
  };
in cfg
