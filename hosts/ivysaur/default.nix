{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (self.lib) merge;

  jay = self.common.users.jay {
    inherit config pkgs;
    modules = with self.common.home-manager-module-sets; cli;
  };

  user-configs = merge [
    jay
  ];
in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    agenix
    generations
    grafana-agent
    home-manager
    logging
    nix
    openssh
    ssh
    ssh
    sudo
    time
    timesyncd
    tmp-tmpfs
    zramSwap
    zsh
  ];

  networking.hostName = lib.mkForce "ivysaur";

  services.openssh.settings.PermitRootLogin = lib.mkForce "no";
}
