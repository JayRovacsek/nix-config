{ config, ... }: {
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    # Poll the `main` branch for changes once every 5 minutes
    dates = "hourly";
    flake = "github:JayRovacsek/nix-config/main#${config.networking.hostName}";
  };
}
