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

  merged = merge [ jay ];
in {
  inherit (merged) users home-manager;

  imports = with self.nixosModules; [
    agenix
    clamav
    disable-assertions
    gnupg
    linode-image
    lorri
    nix
    openssh
    time
    timesyncd
    zsh
  ];

  # Once a ditto, always a ditto.
  environment.systemPackages = [ ditto-transform ] ++ (with pkgs; [ git ]);

  networking.hostName = "diglett";
  system.stateVersion = "24.05";
}
