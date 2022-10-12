{ config, pkgs, ... }:
let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules = [ "alacritty" "firefox" "git" "lsd" "starship" "vscodium" ];
in {
  imports = (builtins.map (module: ./. + "${path}/${module}") modules)
    ++ [ ../../packages/x86_64-darwin.nix ];

  home.file."Nix Applications".source = let
    apps = pkgs.buildEnv {
      name = "home-manager-applications";
      paths = config.home.packages;
      pathsToLink = "/Applications";
    };
  in "${apps}/Applications";
}