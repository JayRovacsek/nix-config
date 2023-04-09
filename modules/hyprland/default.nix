{ config, pkgs, ... }:
let
  nvidiaPatches = builtins.any (driver: driver == "nvidia")
    config.services.xserver.videoDrivers;
in {
  programs.hyprland = {
    enable = true;
    inherit nvidiaPatches;
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  environment = {
    systemPackages = with pkgs; [ pciutils elogind ];
    variables.WLR_NO_HARDWARE_CURSORS = "1";
  };
}
