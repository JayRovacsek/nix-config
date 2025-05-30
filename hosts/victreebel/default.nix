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
      ++ ai
      ++ ssh
      ++ [ { programs.thunderbird.enable = lib.mkForce false; } ];
  };

  user-configs = merge [
    jay
  ];
in
{
  inherit (user-configs) users home-manager;

  system.primaryUser = "j.rovacsek";

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
      agenix
    ];

    variables.EDITOR = "nvim";
  };

  # This is really only required due to a broken install
  ids.gids.nixbld = 350;

  imports = with self.nixosModules; [
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
  ];

  networking = {
    computerName = "victreebel";
    hostName = "victreebel";
    localHostName = "victreebel";
  };

  system.stateVersion = 4;
}
