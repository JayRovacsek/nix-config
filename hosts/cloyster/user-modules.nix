{ config, pkgs, ... }:
let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules = [
    "alacritty"
    "dconf"
    "direnv"
    "firefox"
    "git"
    "lsd"
    "rofi"
    "starship"
    "vscodium"
    "zsh"
  ];
in {
  imports = builtins.map (module: ./. + "${path}/${module}") modules;

  home.file."Nix Applications".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
}
