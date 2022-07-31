{ config, pkgs, isLinux ? true, flake ? { }, ... }:
let
  configs = {
    linux = import ./linux.nix { inherit config flake; };
    darwin = import ./darwin.nix { inherit config flake; };
  };

  appliedConfig = if isLinux then configs.linux else configs.darwin;

in appliedConfig
