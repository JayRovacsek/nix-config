{ config, pkgs, ... }:
let
  base = with pkgs; [ dwarf-fortress ];
  mods = with pkgs.dwarf-fortress-packages; [ dwarf-therapist ];
  themes = with pkgs.dwarf-fortress-packages; [ ];
  dfPackages = base ++ mods ++ themes;
in { home.packages = dfPackages; }
