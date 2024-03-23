{ config, pkgs, lib, self, ... }:

let
  inherit (self) common;
  inherit (self.lib) merge;
  inherit (self.common.home-manager-module-sets) hyprland-desktop;

  test = common.users.test {
    inherit config pkgs;
    modules = hyprland-desktop;
  };

  merged = merge [ test ];

in {
  inherit (merged) users home-manager;

  environment.systemPackages = with pkgs; [ curl wget ];

  imports = with self.nixosModules; [
    agenix
    disable-assertions
    hyprland
    lorri
    nix
    time
    timesyncd
    zsh
  ];

  networking = {
    hostName = "mew";
    useDHCP = true;
  };

  system.stateVersion = "22.11";
}
