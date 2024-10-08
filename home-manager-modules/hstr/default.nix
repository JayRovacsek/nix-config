{ config, ... }:
let
  enable = true;

  enableBashIntegration = config.programs.bash.enable;
  enableZshIntegration = config.programs.zsh.enable;

in
{
  programs.hstr = {
    inherit enable enableBashIntegration enableZshIntegration;
  };
}
