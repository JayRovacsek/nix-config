{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) merge;

  jay = self.common.users."j.rovacsek" {
    inherit config pkgs;
    modules =
      with self.common.home-manager-module-sets;
      darwin-desktop
      ++ ssh
      ++ [
        { programs.thunderbird.enable = lib.mkForce false; }
        {
          home.packages = with pkgs; [
            # Required for work operations
            awscli2
            # Alterative browser to test assumptions
            brave
          ];
        }
      ];
  };

  user-configs = merge [
    jay
  ];
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

  environment = {
    systemPackages = with pkgs; [
      # Manage secrets
      agenix
      # Get mac application information via cli
      mas
      # Make ssh on mac actually sane
      openssh
      # Make launcher on mac actually sane
      raycast
      # pidof and whatnot
      toybox
    ];

    variables.EDITOR = "nvim";
  };

  # This is really only required due to a broken install
  ids.gids.nixbld = 350;

  imports = (
    with self.nixosModules;
    [
      agenix
      darwin-settings
      docker-darwin
      documentation
      fonts
      gnupg
      lix
      lorri
      networking
      nix
      remote-builds
      skhd
      ssh
      time
      yabai
      zsh
    ]
  );

  networking = {
    computerName = "victreebel";
    hostName = "victreebel";
    localHostName = "victreebel";
  };

  nix.package = lib.mkForce pkgs.lixPackageSets.latest.lix;

  system = {
    primaryUser = "j.rovacsek";
    stateVersion = 4;
  };
}
