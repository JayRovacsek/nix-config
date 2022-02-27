{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    ./system-packages.nix
    ./users.nix
  ];

  networking.hostName = "wigglytuff";
  networking.hostId = "d2a7b80b";
}
