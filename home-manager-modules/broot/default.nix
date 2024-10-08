{ config, ... }:
let
  enable = true;

  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable;

  settings.modal = true;

in
{
  programs.broot = {
    inherit
      enable
      enableBashIntegration
      enableFishIntegration
      enableZshIntegration
      settings
      ;
  };
}
