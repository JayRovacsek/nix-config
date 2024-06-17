{ config, pkgs, self, ... }:
let
  inherit (pkgs) system;
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) cli;
  inherit (self.lib) merge;

  inherit (self.packages.${system}) ditto-transform;

  jay = common.users.jay {
    inherit config pkgs;
    modules = cli;
  };

  user-configs = merge [ jay ];
in {
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    agenix
    disable-assertions
    nix-topology
    clamav
    gnupg
    lorri
    nix
    openssh
    time
    timesyncd
    zsh
  ];

  environment.systemPackages = [ ditto-transform ]
    ++ (with pkgs; [ curl git wget ]);

  networking.hostName = "ditto";
  system.stateVersion = "22.11";
}
