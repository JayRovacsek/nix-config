{ pkgs, lib, self, ... }:
let
  settings = import ./settings.nix { inherit pkgs self; };
  enable = true;
  systemd = {
    enable = true;
    target = "display-manager.service";
  };
in {
  programs.waybar = { inherit enable systemd settings; };
  systemd.user.services.waybar.Service.Restart = lib.mkForce "always";
}
