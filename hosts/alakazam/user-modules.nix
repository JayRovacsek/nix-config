let
  # Relative path to this location
  path = "./../../home-manager-modules";
  # List of home-manager modules we want for this system
  modules = [ "alacritty" "direnv" "firefox" "git" "lsd" "rofi" "starship" "vscodium" "zsh" ];
in {
  imports = (builtins.map (module: ./. + "${path}/${module}") modules)
    ++ [ ../../packages/x86_64-linux.nix ];
}
