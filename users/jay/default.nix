{ config, lib, pkgs, ... }: {
  imports = [ ./home.nix ];

  programs.home-manager.enable = true;

}
