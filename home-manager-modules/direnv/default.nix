{
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [ self.inputs.direnv-instant.homeModules.direnv-instant ];

  programs.direnv = {
    enable = true;
    config = {
      global.load_dotenv = true;
      whitelist.prefix = [ "${config.home.homeDirectory}/dev" ];
    };
    nix-direnv.enable = true;
  };

  programs.direnv-instant = {
    enable =
      !(pkgs.stdenv.hostPlatform.isAarch64 && pkgs.stdenv.hostPlatform.isLinux);
    settings.use_cache = true;
  };
}
