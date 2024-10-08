{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  inherit (self.common.config.services.hydra) badge-port port;

  /*
    *
    Hello fellow hydra user! You might be here given some broad
    search attempt in github to understand what is going on in hydra.
    Hopefully some of the below might be of value! One word of warning
    is the folly that is keeping an allowed uris list small it seems nowadays
    (other than super permissive allow-lists...)

    Note that the below seem to by case-sensitive if it couldn't get much worse
    :'(
  */
  urls = [
    "git+https://git.lix.systems"
    "github:aarowill/base16-alacritty"
    "github:astro/microvm.nix"
    "github:bandithedoge/nixpkgs-firefox-darwin"
    "github:cachix/git-hooks.nix"
    "github:chriskempson/base16-vim"
    "github:danth/stylix"
    "github:edolstra/flake-compat"
    "github:GNOME/gnome-shell"
    "github:hercules-ci/flake-parts"
    "github:hercules-ci/gitignore.nix"
    "github:Infinidoge/nix-minecraft"
    "github:JakeStanger/ironbar"
    "github:JayRovacsek"
    "github:kdrag0n/base16-kitty"
    "github:lnl7/nix-darwin"
    "github:ners/nix-monitored"
    "github:nix-community"
    "github:nix-systems/default"
    "github:NixOS/nixos-hardware"
    "github:nixos/nixpkgs"
    "github:NixOS/nixpkgs"
    "github:numtide/devshell"
    "github:numtide/flake-utils"
    "github:numtide/treefmt-nix"
    "github:oddlama/nix-topology"
    "github:oxalica/rust-overlay"
    "github:ryantm/agenix"
    "github:SenchoPens/base16.nix"
    "github:SenchoPens/fromYaml"
    "github:srid/flake-root"
    "github:SuperSandro2000/nixos-modules"
    "github:terranix/terranix"
    "github:tiiuae/sbomnix"
    "github:tinted-theming/base16-foot"
    "github:tinted-theming/base16-helix"
    "github:tinted-theming/base16-tmux"
    "github:tomyun/base16-fish"
    "https://github.com/NixOS"
  ];
in
{
  imports = [ self.inputs.hydra-badge-api.nixosModules.default ];

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
      builder-id-ed25519 = lib.mkForce {
        file = ../../secrets/ssh/builder-id-ed25519.age;
        owner = config.users.users.hydra-queue-runner.name;
        mode = "0400";
      };

      hydra-github-token = {
        file = ../../secrets/hydra/hydra-github-token.age;
        owner = config.users.users.hydra.name;
        inherit (config.users.users.hydra) group;
        mode = "0440";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];

  nix.settings.allowed-uris = lib.concatStringsSep " " urls;

  services.hydra = {
    enable = true;
    badgeApi = {
      enable = true;
      instance = config.services.hydra.hydraURL;
      port = badge-port;
    };
    # READ INTO: https://hydra.nixos.org/build/196107287/download/1/hydra/plugins/index.html?highlight=github#github-status
    extraConfig = ''
      compress_build_logs = 1
      <githubstatus>
        jobs = .*
        useShortContext = true
        Include ${config.age.secrets.hydra-github-token.path}
      </githubstatus>
    '';
    hydraURL = "https://hydra.rovacsek.com";
    listenHost = "*";
    minimumDiskFree = 25;
    minimumDiskFreeEvaluator = 50;
    notificationSender = "";
    package = pkgs.hydra;
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
