{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  using-wayland =
    with config.wayland.windowManager;
    (hyprland.enable || river.enable || sway.enable);

  darwin-packages = [ ];

  linux-packages = with pkgs; [
    # Browsers
    brave

    # Productivity
    gimp
    (if using-wayland then jellyfin-media-player-wayland else jellyfin-media-player)

    # Communication
    signal-desktop
    thunderbird
  ];

  # TODO: refactor this into a getAttr rather than if statement.
  cfg =
    if lib.hasInfix "darwin" osConfig.nixpkgs.system then
      { home.packages = darwin-packages; }
    else
      { home.packages = linux-packages; };
in
cfg
