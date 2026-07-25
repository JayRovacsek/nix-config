{
  config,
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
    enable = true;
    settings.use_cache = true;
  };
}
