{ config, pkgs, ... }:
let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules = [
    "alacritty"
    "bat"
    "dircolours"
    "direnv"
    "firefox"
    "fzf"
    "git"
    "jq"
    "lsd"
    "man"
    "starship"
    "vscodium"
    "zsh"
  ];
in {
  imports = (builtins.map (module: ./. + "${path}/${module}") modules)
    ++ [ ../../packages/darwin.nix ];

  home.file."Nix Applications".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
}
