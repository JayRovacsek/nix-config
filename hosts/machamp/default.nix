{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib) merge;

  jay = self.common.users."jay.rovacsek" {
    inherit config pkgs;
    modules =
      with self.common.home-manager-module-sets;
      # As per the darwin-desktop set, but with claude-code in place of the ai
      # set and without dbt.
      [ self.homeManagerModules.claude-code ]
      ++ desktop
      ++ (with self.homeManagerModules; [
        alacritty
        dock
        home-manager-darwin
        utm
      ])
      ++ [
        {
          manual.manpages.enable = false;
        }
      ]
      ++ ssh
      ++ [
        {
          home.packages = with pkgs; [
            # Required for work operations
            awscli2
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
        owner = "jay.rovacsek";
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
    ];

    variables.EDITOR = "nvim";
  };

  homebrew.casks = lib.mkForce [
    "claude"
    "google-chrome"
    "nextcloud"
    "okta-verify"
  ];

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
    computerName = "GCXHT2LG6N-MBP-2611";
    hostName = "GCXHT2LG6N-MBP-2611";
    localHostName = "GCXHT2LG6N-MBP-2611";
  };

  ids.gids.nixbld = 350;

  nix = {
    # Lix 2.96 sandbox profile fails every local build on macOS 27.2 (exit 1, no log).
    # "relaxed" only honours __noChroot derivations so it does not help; remove once fixed upstream.
    settings.sandbox = lib.mkForce false;

    # Drive nix-monitored with the nixpkgs Lix 2.96 package set rather than the
    # lix flake input.
    monitored.package = lib.mkForce (
      self.inputs.nix-monitored.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        nix = pkgs.lixPackageSets.lix_2_96.lix;
      }
    );

    # Run the linux builder with upstream defaults; the customised builder VM
    # cannot be built locally while the sandbox is broken (see above).
    linux-builder = {
      ephemeral = lib.mkForce false;
      maxJobs = lib.mkForce 1;
      config = lib.mkForce { };
    };
  };

  system = {
    primaryUser = "jay.rovacsek";
    stateVersion = 4;
  };
}
