{ config, pkgs, overrides ? { }, ... }:
let inherit (pkgs.lib.attrsets) recursiveUpdate;
in recursiveUpdate overrides {
  programs.man = {
    enable = true;
    generateCaches = true;
  };
}
