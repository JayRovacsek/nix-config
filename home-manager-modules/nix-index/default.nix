{ config, osConfig, ... }:
let
  enable = true;

  enableBashIntegration = config.programs.bash.enable
    && osConfig.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable
    && osConfig.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable
    && osConfig.programs.zsh.enable;

in {
  programs.nix-index = {
    inherit enable enableBashIntegration enableFishIntegration
      enableZshIntegration;
  };
}
