{ config, ... }:
let
  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable;
in
{
  programs.lsd = {
    enable = true;

    inherit
      enableBashIntegration
      enableFishIntegration
      enableZshIntegration
      ;

    settings = {
      classic = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
      ];
      color.when = "auto";
      date = "date";
      dereference = false;
      indicators = false;
      layout = "grid";
      recursion.enabled = false;
      size = "default";
      no-symlink = false;
      total-size = false;
      symlink-arrow = "⇒";

      icons = {
        when = "auto";
        theme = "fancy";
        separator = " ";
      };

      sorting = {
        column = "name";
        reverse = false;
        dir-grouping = "none";
      };
    };
  };
}
