{ config, pkgs, lib, flake, ... }:
let
  inherit (pkgs) system;

  inherit (flake) common;
  inherit (flake.common.home-manager-module-sets) darwin-desktop;
  inherit (flake.lib) merge;
  inherit (config.flake.packages.${system}) cloudquery cvemap;

  jay = common.users."j.rovacsek" {
    inherit config pkgs;
    modules = darwin-desktop;
  };
  merged = merge [ jay ];
in {
  inherit flake;
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

  environment.systemPackages = [ cloudquery cvemap ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "victreebel";
    hostName = "victreebel";
    localHostName = "victreebel";
  };

  system.stateVersion = 4;
}
