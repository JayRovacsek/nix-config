{
  config,
  lib,
  osConfig,
  pkgs,
  self,
  ...
}:
let
  # Check if nvidia drivers are present on the host, we can assume if
  # yes, we can/should apply some opinions
  nvidia-present = builtins.any (
    driver: driver == "nvidia"
  ) osConfig.services.xserver.videoDrivers;

  # Set some ENV variables if nvidia is present
  optional-env-values = lib.optionalAttrs nvidia-present {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
  };
in
{
  home = {
    # https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
    # Add vaapi drivers if nvidia is present
    packages = lib.optionals nvidia-present (
      with pkgs;
      [
        libva
        nvidia-vaapi-driver
      ]
    );

    sessionVariables = {
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11,*";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    } // optional-env-values;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = import ./settings.nix {
      inherit
        config
        pkgs
        osConfig
        self
        ;
    };
  };
}
