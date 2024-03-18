{ config, pkgs, self, ... }:
let
  inherit (pkgs) lib;
  nvidia-present = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;

  package = pkgs.hyprland;

  # https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
  optional-packages =
    lib.optionals nvidia-present (with pkgs; [ libva nvidia-vaapi-driver ]);

  systemPackages = (with pkgs; [
    libsForQt5.qt5.qtwayland
    pciutils
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
  ]) ++ optional-packages;

  optional-env-values = lib.optionalAttrs nvidia-present {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

in {
  nixpkgs.overlays = with self.inputs; [ nixpkgs-wayland.overlay ];

  services.xserver.displayManager.defaultSession = "hyprland";

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
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      GDK_BACKEND = "wayland";
      WLR_DRM_NO_ATOMIC = "1";
      MOZ_ENABLE_WAYLAND = "1";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
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

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };
    pulseaudio.support32Bit = true;
  };

  xdg.portal.enable = true;
}
