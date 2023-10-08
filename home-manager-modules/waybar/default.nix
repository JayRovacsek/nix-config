{ pkgs, osConfig, lib, ... }:
let
  settings = import ./settings.nix { inherit pkgs osConfig; };
  enable = true;
  systemd = {
    enable = true;
    target = "display-manager.service";
  };
in {
  programs.waybar = { inherit enable systemd settings; };
  systemd.user.services.waybar.Service.Restart = lib.mkForce "always";
}
