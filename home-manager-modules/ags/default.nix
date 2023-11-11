{ pkgs, ... }: {
  programs.ags = {
    enable = true;
    configDir = pkgs.ags-config + "/lib/node_modules/ags-config";
  };

  home.packages = with pkgs; [
    brightnessctl
    hyprpicker
    inotify-tools
    papirus-icon-theme
    playerctl
    sassc
    swww
  ];
}
