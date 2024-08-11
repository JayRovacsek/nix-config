{ pkgs, self, ... }:
let
  inherit (self.packages.${pkgs.system}) mario-homelab-pixelart-wallpaper;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = [ "${mario-homelab-pixelart-wallpaper}/share/wallpaper.jpg" ];

      wallpaper = [ ",${mario-homelab-pixelart-wallpaper}/share/wallpaper.jpg" ];
    };
  };
}
