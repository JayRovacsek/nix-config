{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (pkgs) system;

  inherit (self.lib) merge;
  inherit (self.packages.${system}) cloudquery cvemap trdsql;

  jay = self.common.users."j.rovacsek" {
    inherit config pkgs;
    modules = with self.common.home-manager-module-sets; darwin-desktop ++ ssh;
  };

  user-configs = merge [ jay ];
in
{
  inherit (user-configs) users home-manager;

  age = {
    identityPaths = [ "/private/var/agenix/id-ed25519-ssh-primary" ];
    secrets =
      let
        owner = "j.rovacsek";
      in
      {
        git-signing-key = {
          inherit owner;
          file = ../../secrets/ssh/git-signing-key.age;
          path = "/Users/${owner}/.ssh/git-signing-key";
        };

        "git-signing-key.pub" = {
          inherit owner;
          file = ../../secrets/ssh/git-signing-key.pub.age;
          path = "/Users/${owner}/.ssh/git-signing-key.pub";
        };

        type-a-1 = lib.mkForce {
          inherit owner;
          file = ../../secrets/ssh/type-a-1.age;
        };

        type-a-2 = lib.mkForce {
          inherit owner;
          file = ../../secrets/ssh/type-a-2.age;
        };

        type-c-1 = lib.mkForce {
          inherit owner;
          file = ../../secrets/ssh/type-c-1.age;
        };

        type-c-2 = lib.mkForce {
          inherit owner;
          file = ../../secrets/ssh/type-c-2.age;
        };
      };
  };

  environment.systemPackages = with pkgs; [
    agenix
    cloudquery
    cvemap
    trdsql
  ];

  imports = with self.nixosModules; [
    agenix
    darwin-settings
    docker-darwin
    dockutil
    documentation
    fonts
    gnupg
    lix
    lorri
    networking
    nix
    nix-monitored
    remote-builds
    skhd
    ssh
    time
    yabai
  ];

  networking = {
    computerName = "victreebel";
    hostName = "victreebel";
    localHostName = "victreebel";
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
