{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg = lib.mkIf pkgs.stdenv.isLinux {
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
