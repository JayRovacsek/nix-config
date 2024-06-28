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

  # Once a ditto, always a ditto.
  environment.systemPackages = [ ditto-transform ] ++ (with pkgs; [ git ]);

  imports = with self.nixosModules; [
    agenix
    amazon-image
    clamav
    disable-assertions
    nix-topology
    gnupg
    lorri
    nix
    openssh
    ssm
    time
    timesyncd
    zsh
  ];

  networking.hostName = "butterfree";
  system.stateVersion = "23.05";
}
