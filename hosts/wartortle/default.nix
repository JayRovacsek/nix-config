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
    modules = with self.common.home-manager-module-sets; cli ++ impermanence;
  };

  user-configs = merge [
    jay
  ];
in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    ./disk-config.nix
    agenix
    generations
    grafana-agent
    home-manager
    impermanence
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

  networking.hostName = lib.mkForce "wartortle";

  services.openssh.settings.PermitRootLogin = lib.mkForce "no";
}
