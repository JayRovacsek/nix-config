{ config, pkgs, lib, self, ... }:
let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) cli;
  inherit (self.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  merged = merge [ jay ];

  hostName = "zubat";
in {
  inherit (merged) users home-manager;

  age.identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];

  environment.systemPackages = with pkgs; [
    # CLI
    curl
    wget
  ];

  networking = { inherit hostName; };

  wsl = {
    defaultUser = "jay";
    enable = true;
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  system.stateVersion = "22.05";
}
