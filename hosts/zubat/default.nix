{ config, pkgs, lib, flake, ... }:
let
    userConfigs = import ./users.nix { inherit config pkgs flake; };
    users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };
  hostName = "zubat";
in
{
  inherit users flake;

  age.identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];

  imports = [
    ./modules.nix
    ./options.nix
    ./system-packages.nix
  ];

  networking = { inherit hostName; };

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "jay";
    startMenuLaunchers = true;
  };

  # nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}
