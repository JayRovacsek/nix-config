{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) darwin-desktop;
  inherit (self.lib) merge;

  jay = common.users."jrovacsek" {
    inherit config pkgs;
    modules = darwin-desktop;
  };
  user-configs = merge [ jay ];
in
{
  inherit (user-configs) users home-manager;

  age.secrets = {
    jrovacsek-id-ed25519-sk-type-a-1 = {
      file = ../../secrets/ssh/jay-id-ed25519-sk-type-a-1.age;
      owner = "jrovacsek";
    };

    jrovacsek-id-ed25519-sk-type-a-2 = {
      file = ../../secrets/ssh/jay-id-ed25519-sk-type-a-2.age;
      owner = "jrovacsek";
    };

    jrovacsek-id-ed25519-sk-type-c-1 = {
      file = ../../secrets/ssh/jay-id-ed25519-sk-type-c-1.age;
      owner = "jrovacsek";
    };

    jrovacsek-id-ed25519-sk-type-c-2 = {
      file = ../../secrets/ssh/jay-id-ed25519-sk-type-c-2.age;
      owner = "jrovacsek";
    };
  };

  environment.systemPackages = with pkgs; [ agenix ];

  imports = with self.nixosModules; [
    agenix
    darwin-settings
    docker-darwin
    dockutil
    documentation
    fonts
    gnupg
    lorri
    networking
    nix
    nix-monitored
    nix-topology
    time
    yabai
    zsh
  ];

  services.nix-daemon.enable = true;

  networking = {
    computerName = "ninetales";
    hostName = "ninetales";
    localHostName = "ninetales";
  };

  system.stateVersion = 4;
}
