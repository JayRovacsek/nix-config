{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        DEVELOPMENT = "${config.home.homeDirectory}/dev";
      };
    };
  };
}
