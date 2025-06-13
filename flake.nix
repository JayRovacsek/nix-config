{
  description = "NixOS/Darwin configurations";

  inputs = {
    # Stable / Unstable split in packages
    bleeding-edge.url = "github:nixos/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/release-25.05";

    # Secrets Management <3
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

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    # Adds flake compatibility to start removing the vestiges of
    # shell.nix and move us towards the more modern nix develop
    # setting while tricking some services/plugins to still be able to
    # use the shell.nix file.
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

    # Adds configurable pre-commit options to our flake :)
    git-hooks = {
      inputs = {
        flake-compat.follows = "flake-compat";
        gitignore.follows = "gitignore";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/git-hooks.nix";
    };

    gitignore = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hercules-ci/gitignore.nix";
    };

    # Home management module
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

    # Modules to help you handle persistent state on systems with ephemeral root storage.
    impermanence.url = "github:nix-community/impermanence";

    ironbar = {
      inputs = {
        flake-compat.follows = "flake-compat";
        naersk.follows = "naersk";
        nixpkgs.follows = "nixpkgs";
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
        pre-commit-hooks.follows = "git-hooks";
      };
      url = "git+https://git.lix.systems/lix-project/lix?ref=refs/tags/2.93.0";
    };

    lix-hydra = {
      inputs = {
        flake-compat.follows = "flake-compat";
        lix.follows = "lix";
        nixpkgs.follows = "nixpkgs";
      };
      url = "git+https://git.lix.systems/lix-project/hydra?rev=95bb3ba23f69d474c88ec0ec9c35fd53fffeb3f1";
    };

    lix-module = {
      inputs = {
        flake-utils.follows = "flake-utils";
        lix.follows = "lix";
        nixpkgs.follows = "nixpkgs";
      };
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
    };

    microvm = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:astro/microvm.nix/e8d5f12b834a59187c7ec147a8952a0567f97939";
    };

    naersk = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/naersk";
    };

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin/master";
    };

    nix-eval-jobs = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nix-github-actions.follows = "nix-github-actions";
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
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Infinidoge/nix-minecraft";
    };

    nix-monitored = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ners/nix-monitored";
    };

    nix-topology = {
      inputs = {
        devshell.follows = "devshell";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
      };
      url = "github:oddlama/nix-topology";
    };

    # Generate system images easily
    nixos-generators = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-generators";
    };

    # Apply opinions on hardware that are driven by community
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixos modules to be used in the Windows Subsystem for Linux
    nixos-wsl = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/NixOS-WSL/3721fe7c056e18c4ded6c405dbee719692a4528a";
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
        nuschtosSearch.follows = "nuschtosSearch";
      };
      url = "github:nix-community/nixvim";
    };

    # Like the Arch User Repository, but better :)
    nur = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:nix-community/NUR";
    };

    nuschtosSearch = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:NuschtOS/search";
    };

    nuschtos-modules = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:NuschtOS/nixos-modules";
    };

    # Duplicate nixpkgs input is expected here: we want to align with upstream
    # to avoid cache misses leading to kernel compiles
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

    sbomnix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        flake-root.follows = "flake-root";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:tiiuae/sbomnix";
    };

    # Software bill of materials package
    stylix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        git-hooks.follows = "git-hooks";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        systems.follows = "systems";
      };
      url = "github:danth/stylix";
    };

    systems.url = "github:nix-systems/default";

    # Opentofu via the nix language
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
      flake-utils-output = flake-utils.lib.eachDefaultSystem (
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

          # Pre-commit hooks to enforce formatting, lining, find
          # antipatterns and ensure they don't reach upstream
          checks = {
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
                nixfmt-rfc-style = {
                  enable = true;
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
                      "authorized"
                      "ba"
                      "browseable"
                      "center"
                      "centered"
                      "crypted"
                      "customize"
                      "dota"
                      "ede"
                      "flor"
                      "Flor"
                      "gastly"
                      "Gastly"
                      "Iy"
                      "maximize"
                      "minimize"
                      "ND"
                      "no"
                      "noice"
                      "noo"
                      "normalization"
                      "Normalizations"
                      "Normalized"
                      "normalizer"
                      "Ot"
                      "Pn"
                      "prioritize"
                      "Recognize"
                      "sanitize"
                      "SART"
                      "Serialization"
                      "strat"
                      "SYNOPSYS"
                      "UE"
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
                  enable = pkgs.stdenv.isLinux;
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
              nixfmt-rfc-style
              nodePackages.prettier
              statix
              trufflehog
              typos
            ];
          };

          # Formatter option for `nix fmt` - redundant via checks but nice to have
          formatter = pkgs.nixfmt-rfc-style;

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
