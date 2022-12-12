{ config, pkgs, lib, flake, ... }:
let
    userConfigs = import ./users.nix { inherit config pkgs flake; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
in
{
    inherit users flake;

  imports = [
    # "${modulesPath}/profiles/minimal.nix"
    ./modules.nix
    ./options.nix
    ./system-packages.nix
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;
  };

  # nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}
