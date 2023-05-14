{ config, pkgs, ... }:
let
  inherit (pkgs) system;
  inherit (config.flake.packages.${system}.sddm-themes) chili;
  inherit (pkgs.libsForQt5.qt5) qtgraphicaleffects;
in {
  environment.systemPackages = [ chili qtgraphicaleffects ];
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      settings = {
        General = {
          DisplayServer = "wayland";
          GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
        };

        Wayland = { CompositorCommand = ""; };
      };
      theme = "chili";
    };
  };
}
