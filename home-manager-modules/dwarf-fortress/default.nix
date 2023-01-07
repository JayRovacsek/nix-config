{ config, pkgs, ... }:
let
  base = [ dwarf-fortress ];
  mods = with dwarf-fortress-packages; [ dwarf-therapist ];
  themes = with dwarf-fortress-packages; [ ];
  dfPackages = base ++ mods ++ themes;
  cfg = { home.packages = dfPackages; };
in cfg
