{ config, ... }:
let
  enable = true;

  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable;

in
{
  programs.nix-index = {
    inherit
      enable
      enableBashIntegration
      enableFishIntegration
      enableZshIntegration
      ;
  };
}
