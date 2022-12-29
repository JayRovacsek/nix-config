{ config, pkgs, overrides ? { }, ... }:
let inherit (pkgs.lib.attrsets) recursiveUpdate;
in recursiveUpdate overrides {
  programs.direnv = {
    enable = true;
    config = {
      global = { load_dotenv = true; };
      whitelist = {
        prefix =
          [ "/home/jay/dev" "/Users/j.rovacsek/dev" "/Users/jrovacsek/dev" ];
      };
    };
  };
}
