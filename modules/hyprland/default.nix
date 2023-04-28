{ config, pkgs, ... }:
let
  inherit (pkgs) system lib;
  nvidia-present = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;

  nvidiaPatches = nvidia-present;

  package = if nvidia-present then
    config.flake.inputs.hyprland.packages.${system}.hyprland-nvidia
  else
    config.flake.inputs.hyprland.packages.${system}.default;
in {
  nixpkgs.overlays = with config.flake.inputs; [ nixpkgs-wayland.overlay ];

  programs.hyprland = {
    enable = true;
    inherit nvidiaPatches package;
    xwayland.enable = true;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  environment = {
    systemPackages = with pkgs; [
      libsForQt5.qt5.qtwayland
      pciutils
      pciutils
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
    ];
    variables = {
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
      # Resolves jellyfin black screen under hyperland
      # See also: https://github.com/jellyfin/jellyfin-media-player/issues/165#issuecomment-1030690851
      QT_QPA_PLATFORM = "xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
    };
    pulseaudio.support32Bit = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = lib.mkForce [
      config.flake.inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland
    ];
  };
}
