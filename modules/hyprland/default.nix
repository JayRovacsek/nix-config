{ config, lib, pkgs, self, ... }:
let
  nvidia-present = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;

  package = pkgs.hyprland;

  # https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
  optional-packages =
    lib.optionals nvidia-present (with pkgs; [ libva nvidia-vaapi-driver ]);

  systemPackages = (with pkgs; [ libsForQt5.qt5.qtwayland pciutils ])
    ++ optional-packages;

  optional-env-values = lib.optionalAttrs nvidia-present {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

in {
  nixpkgs.overlays = with self.inputs; [ nixpkgs-wayland.overlay ];

  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    inherit package;
    xwayland.enable = true;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  environment = {
    inherit systemPackages;
    variables = {
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      CLUTTER_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "x11";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    } // optional-env-values;
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };
    pulseaudio.support32Bit = true;
  };

  xdg.portal.enable = true;
}
