{ config, pkgs, overrides ? { }, ... }:
let inherit (pkgs.lib.attrsets) recursiveUpdate;
in recursiveUpdate overrides { programs.kitty = { enable = true; }; }
