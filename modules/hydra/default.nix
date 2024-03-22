{ config, pkgs, lib, self, ... }:
let
  inherit (self.common.networking.services.hydra) port;
  urls = [
    "github:astro/microvm.nix"
    "github:Aylur/ags"
    "github:bandithedoge/nixpkgs-firefox-darwin"
    "github:cachix/pre-commit-hooks.nix"
    "github:danth/stylix"
    "github:DeterminateSystems/flake-schemas"
    "github:edolstra/flake-compat"
    "github:hercules-ci/flake-parts"
    "github:hercules-ci/gitignore.nix"
    "github:JayRovacsek/ags-config"
    "github:lnl7/nix-darwin"
    "github:ners/nix-monitored"
    "github:nix-community"
    "github:nix-systems/default"
    "github:NixOS/nixos-hardware"
    "github:nixos/nixpkgs"
    "github:numtide/flake-utils"
    "github:numtide/nix-filter"
    "github:numtide/treefmt-nix"
    "github:ryantm/agenix"
    "github:SenchoPens/base16.nix"
    "github:terranix/terranix"
    "github:tiiuae/sbomnix"
  ];
in {
  # If Hydra is present, we assume a builder user is also present generally
  # to enable remote builds. However we need to force ownership of the key
  # to hydra so that it may evaluate remote builds correctly also otherwise
  # it will be refused access to the SSH key.
  # The permission sets are equivalent between hydra and builder given
  # both have access to the nix store. This doesn't really reduce security even
  # if it looks wonky - root still is assumed in the build process and therefore
  # doesn't care about the 400 permission.
  age = {
    identityPaths = [ "/agenix/id-ed25519-hydra-primary" ];
    secrets = {
      "builder-id-ed25519" = lib.mkForce {
        file = ../../secrets/ssh/builder-id-ed25519.age;
        owner = config.users.users.hydra-queue-runner.name;
        mode = "0400";
      };

      "hydra-github-token" = {
        file = ../../secrets/hydra/hydra-github-token.age;
        owner = config.users.users.hydra.name;
        inherit (config.users.users.hydra) group;
        mode = "0440";
      };
    };
  };

  environment.etc."hydra/github_token" = {
    inherit (config.users.users.hydra) group;
    mode = "440";
    source = config.age.secrets.hydra-github-token.path;
    user = config.users.users.hydra-queue-runner.name;
  };

  networking.firewall.allowedTCPPorts = [ port ];

  nix.extraOptions = ''
    allowed-uris = ${lib.concatStringsSep " " urls}
  '';

  services.hydra = {
    enable = true;
    # READ INTO: https://hydra.nixos.org/build/196107287/download/1/hydra/plugins/index.html?highlight=github#github-status
    extraConfig = ''
      compress_build_logs = 1
      <githubstatus>
        jobs = .*
        inputs = src
        useShortContext = true
      </githubstatus>
    '';
    hydraURL = "https://hydra.rovacsek.com";
    listenHost = "*";
    minimumDiskFree = 25;
    minimumDiskFreeEvaluator = 50;
    notificationSender = "";
    package = pkgs.hydra_unstable;
    inherit port;
    smtpHost = null;
    tracker = "";
    useSubstitutes = true;
  };

  systemd.services = {
    hydra-evaluator.serviceConfig.Group = config.users.users.hydra.group;
    hydra-notify.serviceConfig.Group = config.users.users.hydra.group;
  };
}
