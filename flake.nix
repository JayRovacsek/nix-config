{
  description = "NixOS/Darwin configurations";

  inputs = {
    # Stable / Unstable split in packages
    bleeding-edge.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/release-26.05";

    agenix = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:ryantm/agenix";
    };

    devshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/devshell";
    };

    direnv-instant = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:Mic92/direnv-instant";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-root.url = "github:srid/flake-root";

    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };

    git-hooks = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/git-hooks.nix";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    hydra-badge-api = {
      inputs = {
        devshell.follows = "devshell";
        flake-utils.follows = "flake-utils";
        git-hooks.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:JayRovacsek/hydra-badge-api";
    };

    impermanence = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
      url = "github:nix-community/impermanence";
    };

    ironbar = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        nix-systems.follows = "systems";
      };
      url = "github:JakeStanger/ironbar";
    };

    lib-aggregate = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs-lib.follows = "nixpkgs";
      };
      url = "github:nix-community/lib-aggregate";
    };

    lix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        # These shouldn't be overridden, but generally cause a large amount
        # of extra store paths to be populated, being old nixpkgs references.
        # The use of these attributes from my current understanding is just testing
        # for lix, which we utilise pinned versions anyway.
        nixpkgs-regression.follows = "nixpkgs";
        nix_2_18.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
      };
      url = "git+https://git.lix.systems/lix-project/lix?ref=refs/tags/2.95.3";
    };

    microvm = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:astro/microvm.nix/e8d5f12b834a59187c7ec147a8952a0567f97939";
    };

    nixbot = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:Mic92/nixbot";
    };

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin/master";
    };

    nix-eval-jobs = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:nix-community/nix-eval-jobs";
    };

    nix-github-actions = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-github-actions";
    };

    nix-minecraft = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:Infinidoge/nix-minecraft";
    };

    nix-monitored = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ners/nix-monitored";
    };

    nix-topology = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:oddlama/nix-topology";
    };

    nixos-generators = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-generators";
    };

    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:NixOS/nixos-hardware/master";
    };

    nixos-wsl = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/NixOS-WSL";
    };

    nixpkgs-wayland = {
      inputs = {
        flake-compat.follows = "flake-compat";
        lib-aggregate.follows = "lib-aggregate";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nixpkgs-wayland";
    };

    nixvim = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:nix-community/nixvim/main";
    };

    nur = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/NUR";
    };

    nuschtos-modules = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:NuschtOS/nixos-modules";
    };

    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/develop";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    sbomnix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        flake-root.follows = "flake-root";
        git-hooks-nix.follows = "git-hooks";
        nixpkgs.follows = "nixpkgs";
        vulnix.follows = "vulnix";
      };
      url = "github:tiiuae/sbomnix";
    };

    stylix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        systems.follows = "systems";
      };
      url = "github:danth/stylix";
    };

    systems.url = "github:nix-systems/default";

    terranix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:terranix/terranix";
    };

    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };

    vulnix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        flake-root.follows = "flake-root";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:nix-community/vulnix";
    };
  };

  outputs =
    { self, flake-utils, ... }:
    let
      inherit (self.inputs.nixpkgs) lib;
      inherit (lib) recursiveUpdate;

      standard-outputs = {
        # Common/consistent values to be consumed by the flake
        common = import ./common { inherit self; };

        githubActions = self.inputs.nix-github-actions.lib.mkGithubMatrix {
          # TODO:
          # re-introduce darwin packages
          # checks for pre-commits
          # nixosConfigurations for all suitable hosts
          checks = lib.getAttrs [ "x86_64-linux" ] self.hydraJobs.packages;
        };

        homeManagerModules = builtins.foldl' (
          accumulator: module:
          recursiveUpdate {
            ${module} =
              args@{
                config,
                darwinConfig ? { },
                lib,
                modulesPath,
                nixosConfig ? { },
                options,
                osConfig,
                pkgs,
                self,
                specialArgs,
                ...
              }:
              import ./home-manager-modules/${module} (
                {
                  inherit
                    config
                    darwinConfig
                    lib
                    modulesPath
                    nixosConfig
                    options
                    osConfig
                    pkgs
                    self
                    specialArgs
                    ;
                }
                // args
              );
          } accumulator
        ) { } self.common.home-manager-modules;

        # Automated build configuration for local packages
        hydraJobs = import ./hydra { inherit self lib; };

        # Useful functions to use throughout the flake
        lib = import ./lib { inherit self; };

        # System modules for system consumption
        nixosModules = builtins.foldl' (
          accumulator: module:
          recursiveUpdate {
            ${module} =
              args@{
                config,
                lib,
                modulesPath,
                options,
                pkgs,
                self,
                specialArgs,
                ...
              }:
              import ./modules/${module} (
                {
                  inherit
                    config
                    lib
                    modulesPath
                    options
                    pkgs
                    self
                    specialArgs
                    ;
                }
                // args
              );
          } accumulator
        ) { } self.common.nixos-modules;

        options = self.outputs.lib.options.declarations;

        # Overlays for when stuff really doesn't fit in the round hole
        overlays = import ./overlays { inherit self; };

        secrets = import ./secrets { inherit self; };

        # System configurations
        nixosConfigurations = import ./linux { inherit self; };
        darwinConfigurations = import ./darwin { inherit self; };
      };

      # Systems we want to wrap all outputs below in. This is split into
      # two segments; those items inside the flake-utils block and those not.
      # The flake-utils block will automatically generate the <system>
      # sub-properties for all exposed elements as per: https://nixos.wiki/wiki/Flakes#Output_schema
      flake-utils-output =
        flake-utils.lib.eachSystem standard-outputs.common.config.defaultSystems
          (
            system:
            let
              pkgs = import self.inputs.nixpkgs {
                inherit system;
                overlays = with self.inputs; [
                  nix-topology.overlays.default
                  devshell.overlays.default
                ];
              };
            in
            {
              # Space in which exposed derivations can be ran via
              # nix run .#foo - handy in the future for stuff like deploying
              # via terraform or automation tasks that are relatively
              # procedural
              apps = import ./apps { inherit self pkgs; };

              checks = {
                # authelia-auth = import ./tests/authelia-auth.nix { inherit pkgs self; };

                # anubis-integration = import ./tests/anubis-integration.nix {
                #   inherit pkgs self;
                # };
                # anubis-proxy = import ./tests/anubis-proxy.nix { inherit pkgs self; };

                # headscale-declarative = import ./tests/headscale-declarative.nix {
                #   inherit pkgs self;
                # };
                # headscale-integration = import ./tests/headscale-integration.nix {
                #   inherit pkgs self;
                # };

                git-hooks = self.inputs.git-hooks.lib.${system}.run {
                  src = self;
                  hooks = {
                    # Builtin hooks
                    actionlint.enable = true;
                    conform.enable = true;
                    deadnix = {
                      enable = true;
                      settings.edit = true;
                    };
                    nixfmt = {
                      enable = true;
                      package = pkgs.nixfmt;
                      settings.width = 80;
                    };
                    prettier = {
                      enable = true;
                      settings = {
                        ignore-path = [ self.packages.${system}.prettierignore ];
                        write = true;
                      };
                    };

                    typos = {
                      enable = true;
                      settings = {
                        binary = false;
                        exclude = "*.age";
                        ignored-words = [
                          "Adge"
                          "ags"
                          "analyzer"
                          "Analyzers"
                          "authorization"
                          "authorized"
                          "authorizes"
                          "authorizing"
                          "ba"
                          "browseable"
                          "center"
                          "centered"
                          "certifi"
                          "characterized"
                          "chili"
                          "crypted"
                          "customizable"
                          "customize"
                          "defenses"
                          "donut"
                          "dota"
                          "ede"
                          "flor"
                          "Flor"
                          "gastly"
                          "Gastly"
                          "initialize"
                          "initialized"
                          "Iy"
                          "maximize"
                          "minimize"
                          "modeling"
                          "modelling"
                          "ND"
                          "no"
                          "noice"
                          "noo"
                          "normalization"
                          "Normalizations"
                          "Normalized"
                          "normalizer"
                          "optimisation"
                          "optimise"
                          "optimiser"
                          "optimization"
                          "optimize"
                          "optimizer"
                          "organization"
                          "organizations"
                          "organize"
                          "Ot"
                          "personalization"
                          "Pn"
                          "prioritize"
                          "RANDOMIZE"
                          "Randomized"
                          "Recognize"
                          "recognized"
                          "sanitize"
                          "SART"
                          "Serialization"
                          "strat"
                          "synchronized"
                          "Synchronized"
                          "SYNOPSYS"
                          "UE"
                          "utilization"
                          "Utilization"
                          "wih"
                        ];
                        locale = "en-au";
                      };
                    };

                    # Custom hooks
                    statix-write = {
                      enable = true;
                      name = "Statix Write";
                      entry = "${pkgs.statix}/bin/statix fix";
                      language = "system";
                      pass_filenames = false;
                    };

                    trufflehog-verified = {
                      enable = true;
                      name = "Trufflehog Search";
                      entry = "${pkgs.trufflehog}/bin/trufflehog git file://. --since-commit HEAD --only-verified --fail";
                      language = "system";
                      pass_filenames = false;
                    };
                  };
                };
              };

              # Shell environments (applied to both nix develop and nix-shell via
              # shell.nix in top level directory)
              devShells.default = pkgs.devshell.mkShell {
                devshell.startup.git-hooks.text = self.checks.${system}.git-hooks.shellHook;

                name = "nix-config";

                packages = with pkgs; [
                  actionlint
                  conform
                  deadnix
                  git-cliff
                  nixfmt
                  prettier
                  statix
                  trufflehog
                  typos
                ];
              };

              # Formatter option for `nix fmt` - redundant via checks but nice to have
              formatter = pkgs.nixfmt;

              # Locally defined packages for flake consumption or consumption
              # on the nur via: pkgs.nur.repos.JayRovacsek if utilising the nur overlay
              # (all systems in this flake apply this opinion via the common.modules)
              # construct
              packages = import ./packages { inherit self pkgs; };

              topology = import self.inputs.nix-topology {
                inherit pkgs;
                modules = [ self.common.topology ];
              };
            }
          );
    in
    flake-utils-output // standard-outputs;
}
