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
        XDG_DEVELOPMENT_DIR = "${config.home.homeDirectory}/dev";
      };
    };
  };
}
