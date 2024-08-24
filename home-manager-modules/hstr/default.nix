{ config, osConfig, ... }:
let
  enable = true;

  enableBashIntegration =
    config.programs.bash.enable && osConfig.programs.bash.enable;
  enableZshIntegration =
    config.programs.zsh.enable && osConfig.programs.zsh.enable;

in
{
  programs.hstr = {
    inherit enable enableBashIntegration enableZshIntegration;
  };
}
