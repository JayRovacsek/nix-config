{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  nvidiaPatches = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;

  package = config.flake.inputs.hyprland.packages.${system}.default;
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
      pciutils
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
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
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      config.flake.inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
  };
}
