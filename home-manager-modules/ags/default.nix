{ pkgs, ... }: {
  programs.ags = {
    enable = true;
    configDir = pkgs.ags-config + "/share";
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
