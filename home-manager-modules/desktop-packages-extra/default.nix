{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  darwin-packages = [ ];

  linux-packages = with pkgs; [
    # Browsers
    brave

    # Productivity
    gimp
    jellyfin-media-player

    # Communication
    signal-desktop
  ];

  # TODO: refactor this into a getAttr rather than if statement.
  cfg =
    if lib.hasInfix "darwin" osConfig.nixpkgs.system then
      { home.packages = darwin-packages; }
    else
      { home.packages = linux-packages; };
in
cfg
