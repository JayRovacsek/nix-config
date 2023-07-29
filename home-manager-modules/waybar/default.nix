{ pkgs, osConfig, ... }:
let
  settings = import ./settings.nix { inherit pkgs osConfig; };
  enable = true;
  systemd = {
    enable = true;
    target = "display-manager.service";
  };
  package = pkgs.waybar-hyprland;
in {
  programs.waybar = { inherit enable systemd settings package; };
  systemd.user.services.waybar.Service.Restart = lib.mkForce "always";
}
