{ config, pkgs, lib, flake, ... }:
let
  userConfigs = import ./users.nix { inherit config pkgs flake; };
  users = import ../../functions/map-reduce-users.nix {
    inherit config pkgs lib userConfigs;
  };

  usernames = builtins.attrNames users.users;
in {
  inherit users;

  home-manager.users = builtins.foldl' (m: n: m // n) { } (builtins.map
    (username: {
      "${username}".home.file."Nix Applications".source = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = (builtins.map (a: a.package) (builtins.filter (x:
            if (builtins.hasAttr "enable" x
              && builtins.hasAttr "package" x) then
              x.enable
            else
              false) (builtins.attrValues
                config.home-manager.users."${username}".programs)));
          pathsToLink = "/Applications";
        };
      in "${apps}/Applications";
    }) usernames);

  imports = [ ./modules.nix ./system-packages.nix ./secrets.nix ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "cloyster";
    hostName = "cloyster";
    localHostName = "cloyster";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 4;
}
