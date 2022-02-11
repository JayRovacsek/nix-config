{ config, lib, pkgs, ... }: {
  imports = [ ./home ./packages ];

  programs.home-manager.enable = true;

}
