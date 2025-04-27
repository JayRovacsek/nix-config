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
    alloy
    blocky
    generations
    home-manager
    impermanence
    logging
    nix
    nix-topology
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
