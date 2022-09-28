let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules = [ "lsd" "starship" ];
in { imports = builtins.map (module: ./. + "${path}/${module}") modules; }
