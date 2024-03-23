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
in {
  inherit (merged) users home-manager;

  age.identityPaths = [ "/agenix/id-ed25519-ssh-primary" ];

  environment.systemPackages = with pkgs; [
    # CLI
    curl
    wget
  ];

  imports = with self.nixosModules; [
    agenix
    lorri
    nix
    time
    timesyncd
    zsh
    self.inputs.nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "zubat";

  system.stateVersion = "22.05";

  wsl = {
    defaultUser = "jay";
    enable = true;
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
  };
}
