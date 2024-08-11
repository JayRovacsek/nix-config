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
    XDG_SESSION_TYPE = "wayland";
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
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "x11";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
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
