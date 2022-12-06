let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules = [ "direnv" "lsd" "starship" "zsh" ];
in { imports = builtins.map (module: ./. + "${path}/${module}") modules; }
