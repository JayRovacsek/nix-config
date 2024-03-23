{ config, pkgs, lib, self, ... }:
let
  inherit (pkgs) system;

  inherit (self.common.home-manager-module-sets) darwin-desktop;
  inherit (self.lib) merge;
  inherit (self.packages.${system}) cloudquery cvemap trdsql;

  jay = self.common.users."j.rovacsek" {
    inherit config pkgs;
    modules = darwin-desktop;
  };
  merged = merge [ jay ];
in {
  inherit (merged) users home-manager;

  age = {
    identityPaths = [ "/private/var/agenix/id-ed25519-ssh-primary" ];
    secrets = let owner = "j.rovacsek";
    in {
      "git-signing-key" = {
        inherit owner;
        file = ../../secrets/ssh/git-signing-key.age;
        path = "/Users/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = {
        inherit owner;
        file = ../../secrets/ssh/git-signing-key.pub.age;
        path = "/Users/${owner}/.ssh/git-signing-key.pub";
      };

      "j.rovacsek-id-ed25519-sk-type-a-1" = {
        inherit owner;
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-a-1.age;
      };

      "j.rovacsek-id-ed25519-sk-type-a-2" = {
        inherit owner;
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-a-2.age;
      };

      "j.rovacsek-id-ed25519-sk-type-c-1" = {
        inherit owner;
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-c-1.age;
      };

      "j.rovacsek-id-ed25519-sk-type-c-2" = {
        inherit owner;
        file = ../../secrets/ssh/jay-id-ed25519-sk-type-c-2.age;
      };
    };
  };

  environment.systemPackages = [ cloudquery cvemap trdsql ];

  imports = with self.nixosModules; [
    darwin-settings
    docker-darwin
    dockutil
    documentation
    fonts
    gnupg
    lorri
    networking
    nix
    skhd
    time
    yabai
    zsh
  ];

  networking = {
    computerName = "victreebel";
    hostName = "victreebel";
    localHostName = "victreebel";
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
