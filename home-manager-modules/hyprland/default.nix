{ config, pkgs, osConfig, ... }:
let
  inherit (pkgs) lib system;
  inherit (osConfig.flake.inputs.hyprland-plugins.packages.${system})
    csgo-vulkan-fix;

  # Check if nvidia drivers are present on the host, we can assume if
  # yes, we can/should apply some opinions
  nvidia-present = builtins.any (driver: driver == "nvidia")
    osConfig.services.xserver.videoDrivers;

  # Use the nvidia package if nvidia drivers present
  package = if nvidia-present then
    osConfig.flake.inputs.hyprland.packages.${system}.hyprland-nvidia
  else
    osConfig.flake.inputs.hyprland.packages.${system}.default;

  # If nvidia present, add hardware decoding capabilities

  # Apply nvidia patches if available and required
  enableNvidiaPatches = nvidia-present;

  # https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
  # Add vaapi drivers if nvidia is present
  optional-packages =
    lib.optionals nvidia-present (with pkgs; [ libva nvidia-vaapi-driver ]);

  # Set some ENV variables if nvidia is present
  optional-env-values = lib.optionalAttrs nvidia-present {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # 
  packages = (with pkgs; [ csgo-vulkan-fix hyprpicker ]) ++ optional-packages;

  extraConfig = import ./config.nix { inherit config pkgs osConfig; };

in {

  imports = [ ../mako ../ranger ../waybar ../wofi ];

  home = {
    inherit packages;
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      GDK_BACKEND = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      MOZ_ENABLE_WAYLAND = "1";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      # Resolves jellyfin black screen under hyprland
      # See also: https://github.com/jellyfin/jellyfin-media-player/issues/165#issuecomment-1030690851
      QT_QPA_PLATFORM = "xcb";
      SDL_VIDEODRIVER = "x11";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    } // optional-env-values;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    recommendedEnvironment = true;
    inherit enableNvidiaPatches package extraConfig;
  };
}
