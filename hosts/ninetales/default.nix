{ config, pkgs, lib, ... }:
let
  userFunction = import ../../functions/map-reduce-users.nix;
  userConfigs = (import ./users.nix).users;
  users = userFunction { inherit pkgs userConfigs; };
in {
  inherit users;
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
  ];

  networking.hostName = "ninetales";
  networking.hostId = "4148aee3";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelBuildIsCross = true;

  nixpkgs.config.allowUnsupportedSystem = true;
}
