{ config, ... }:
{
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "daily";
    flake = "github:JayRovacsek/nix-config/main#${config.networking.hostName}";
  };
}
