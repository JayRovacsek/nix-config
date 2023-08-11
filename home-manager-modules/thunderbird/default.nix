{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;

  cfg = lib.optionalAttrs isLinux programs.thunderbird {
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
in cfg
