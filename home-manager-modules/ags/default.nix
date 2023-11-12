{ pkgs, osConfig, ... }: {
  programs.ags = {
    enable = true;
    inherit (osConfig.flake.inputs.ags-config) configDir;
  };

  home.packages = with pkgs; [
    brightnessctl
    gnome-icon-theme
    hicolor-icon-theme
    hyprpicker
    inotify-tools
    papirus-icon-theme
    playerctl
    sassc
    swww
    tela-circle-icon-theme
  ];
}
