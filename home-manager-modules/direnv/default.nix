{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  enable = true;
  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;
  enableZshIntegration = config.programs.zsh.enable;

  nix-direnv = {
    enable = true;
    package =
      if osConfig.nix.package.pname == "lix" then
        pkgs.lixPackageSets.stable.nix-direnv
      else
        pkgs.nix-direnv;
  };
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
