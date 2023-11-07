{ pkgs, lib, osConfig, ... }:
let
  inherit (pkgs.stdenv) isAarch64 isLinux;

  # Check if hyprland property exists on host programs, if it doesnt
  # don't attempt to check if enabled otherwise we'd error
  is-hyprland = builtins.hasAttr "hyprland" osConfig.programs
    && osConfig.programs.hyprland.enable;

  nvidia-present = builtins.any (driver: driver == "nvidia")
    osConfig.services.xserver.videoDrivers;

  # Create a overridden derivation of discord that cuts the garbage out
  discord = pkgs.discord.override {
    withOpenASAR = false;
    withVencord = true;
  };

  webcord-vencord = if nvidia-present then
    pkgs.webcord-vencord.overrideAttrs (old: {
      installPhase = builtins.replaceStrings [ "--ozone-platform-hint=auto" ]
        [ "--ozone-platform-hint=auto --disable-gpu --no-update" ]
        old.installPhase;
    })
  else
    pkgs.webcord-vencord;

  use-webcord = is-hyprland || (isAarch64 && isLinux);
  use-discord = !use-webcord;

  # If we're on hyprland (and can assume wayland) or aarch64-linux, use the 
  # webcord-vencord package otherwise use discord override 
  packages = (lib.optional use-webcord webcord-vencord)
    ++ (lib.optional use-discord discord);

in { home = { inherit packages; }; }
