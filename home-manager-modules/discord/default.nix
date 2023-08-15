{ pkgs, lib, osConfig, ... }:
let
  inherit (pkgs) webcord-vencord discord;
  inherit (pkgs.stdenv) isAarch64 isLinux;

  # Check if hyprland property exists on host programs, if it doesnt
  # don't attempt to check if enabled otherwise we'd error
  isHyprland = builtins.hasAttr "hyprland" osConfig.programs
    && osConfig.programs.hyprland.enable;

  # Create a overridden derivation of discord that cuts the garbage out
  discord-override = discord.override {
    withOpenASAR = true;
    withVencord = true;
  };

  useWebcord = isHyprland || (isAarch64 && isLinux);
  useDiscord = !useWebcord;

  # If we're on hyprland (and can assume wayland) or aarch64-linux, use the 
  # webcord-vencord package otherwise use discord override 
  packages = (lib.optional useWebcord webcord-vencord)
    ++ (lib.optional useDiscord discord-override);

in { home = { inherit packages; }; }
