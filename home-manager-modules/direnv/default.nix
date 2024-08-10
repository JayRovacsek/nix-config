{ config, osConfig, ... }:
let
  enable = true;
  enableBashIntegration =
    config.programs.bash.enable && osConfig.programs.bash.enable;
  enableFishIntegration =
    config.programs.fish.enable && osConfig.programs.fish.enable;
  enableZshIntegration =
    config.programs.zsh.enable && osConfig.programs.zsh.enable;

  nix-direnv.enable = true;

in
{
  programs.direnv = {
    inherit
      enable
      enableBashIntegration
      enableFishIntegration
      enableZshIntegration
      nix-direnv
      ;
    config = {
      global.load_dotenv = true;
      whitelist.prefix = [ "${config.home.homeDirectory}/dev" ];
    };
  };
}
