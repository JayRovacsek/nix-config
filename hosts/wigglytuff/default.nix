{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
    ./users.nix
  ];

  networking.hostName = "wigglytuff";
}
