{ pkgs, lib, osConfig, ... }:
let
  inherit (lib.strings) hasInfix;

  darwin-packages = [ ];

  linux-packages = with pkgs; [
    # Browsers
    brave

    # Productivity
    gimp
    jellyfin-media-player
    nextcloud-client

    # Communication
    signal-desktop
    thunderbird
    slack
  ];

  # TODO: refactor this into a getAttr rather than if statement.
  cfg = if hasInfix "darwin" osConfig.nixpkgs.system then {
    home.packages = darwin-packages;
  } else {
    home.packages = linux-packages;
  };
in cfg
