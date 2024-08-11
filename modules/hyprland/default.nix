{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  nvidia-present = builtins.any (
    driver: driver == "nvidia"
  ) config.services.xserver.videoDrivers;

  # https://wiki.hyprland.org/Nvidia/#how-to-get-hyprland-to-possibly-work-on-nvidia
  packages = lib.optionals nvidia-present (
    with pkgs;
    [
      libva
      nvidia-vaapi-driver
    ]
  );

in
{
  environment = {
    systemPackages =
      (with pkgs; [
        libsForQt5.qt5.qtwayland
        pciutils
      ])
      ++ packages;

    variables =
      {
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
        CLUTTER_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "x11";
        WLR_DRM_NO_ATOMIC = "1";
      }
      // (lib.optionalAttrs nvidia-present {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      });
  };

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        vaapiVdpau
      ];
    };
    pulseaudio.support32Bit = true;
  };

  nixpkgs.overlays = with self.inputs; [ nixpkgs-wayland.overlay ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;

  services = {
    dbus.enable = true;
    displayManager.defaultSession = "hyprland";
  };

  xdg.portal.enable = true;
}
