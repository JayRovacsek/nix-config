{ config, ... }:
let
  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable;
in
{
  programs.atuin = {
    enable = true;

    inherit
      enableBashIntegration
      enableFishIntegration
      enableZshIntegration
      ;

    settings = {
      dialect = "uk";
      update_check = false;
      sync_frequency = "5m";
      keymap_mode = "vim-normal";
    };
  };
}
