let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules =
    [ "alacritty" "dconf" "firefox" "lsd" "starship" "rofi" "vscodium" ];
in { imports = builtins.map (module: ./. + "${path}/${module}") modules; }
