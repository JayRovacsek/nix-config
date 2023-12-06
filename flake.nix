{
  description = "NixOS/Darwin configurations";

  inputs = {
    # Stable / Unstable split in packages
    stable.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    bleeding-edge.url = "github:nixos/nixpkgs";

    # Pinned packages/inputs
    # Breaks booting based on update from 2.06 -> 2.12
    # fix applied downstream via grub2 overlay which simply points
    # grub at the stable version.
    "grub-2.06".url =
      "github:nixos/nixpkgs/d9e8d5395ed0fd93ee23114e59ba5449992829a6";

    # Secrets Management <3
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dream2nix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nix-unit.follows = "nix-unit";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
      url = "github:nix-community/dream2nix";
    };

    # Simply required for sane management of Firefox on darwin
    firefox-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
    };

    # Adds flake compatibility to start removing the vestiges of 
    # shell.nix and move us towards the more modern nix develop
    # setting while tricking some services/plugins to still be able to
    # use the shell.nix file.
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };

    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    gitignore = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hercules-ci/gitignore.nix";
    };

    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Home management module
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };

    # Modules to help you handle persistent state on systems with ephemeral root storage.
    impermanence.url = "github:nix-community/impermanence";

    lib-aggregate = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs-lib.follows = "nixpkgs";
      };
      url = "github:nix-community/lib-aggregate";
    };

    # Microvm module, PoC state for implementation
    microvm = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:astro/microvm.nix";
    };

    neovim-flake = {
      inputs = {
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nil.follows = "nil";
        nixpkgs.follows = "nixpkgs";
        rnix-lsp.follows = "rnix-lsp";
        systems.follows = "systems";
        tidalcycles.follows = "tidalcycles";
        zig.follows = "zig";
      };
      url = "github:notashelf/neovim-flake";
    };

    nixci = {
      inputs = {
        crane.follows = "crane";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:srid/nixci";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    nixified-ai = {
      inputs = {
        flake-parts.follows = "flake-parts";
        hercules-ci-effects.follows = "hercules-ci-effects";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nixified-ai/flake";
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
      url =
        "github:nix-community/NixOS-WSL/3721fe7c056e18c4ded6c405dbee719692a4528a";
    };

    nixpkgs-wayland = {
      inputs = {
        flake-compat.follows = "flake-compat";
        lib-aggregate.follows = "lib-aggregate";
        nix-eval-jobs.follows = "nix-eval-jobs";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nixpkgs-wayland";
    };

    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin/master";
    };

    nix-options = {
      inputs = {
        home-manager.follows = "home-manager";
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
      url = "github:JayRovacsek/nix-options";
    };

    nix-eval-jobs = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:nix-community/nix-eval-jobs";
    };

    nix-filter.url = "github:numtide/nix-filter";

    nix-monitored = {
      inputs = {
        nix-filter.follows = "nix-filter";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:ners/nix-monitored";
    };

    nix-unit = {
      inputs = {
        nix-filter.follows = "nix-filter";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:ners/nix-monitored";
    };

    # Like the Arch User Repository, but better :)
    nur.url = "github:nix-community/NUR";

    # Adds configurable pre-commit options to our flake :)
    pre-commit-hooks = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        gitignore.follows = "gitignore";
        nixpkgs-stable.follows = "stable";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/pre-commit-hooks.nix";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs = {
        naersk.follows = "naersk";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Software bill of materials package
    sbomnix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:tiiuae/sbomnix/main";
    };

    # Software bill of materials package
    stylix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:danth/stylix";
    };

    systems.url = "github:nix-systems/default";

    # Opentofu via the nix language
    terranix = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:terranix/terranix";
    };

    tidalcycles = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      url = "github:mitchmindtree/tidalcycles.nix";
    };

    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };

    zig = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:mitchellh/zig-overlay";
    };
  };

  outputs = { self, flake-utils, ... }:
    let
      inherit (self.inputs.nixpkgs) lib;

      standard-outputs = {
        # Common/consistent values to be consumed by the flake
        common = import ./common { inherit self; };

        # Automated build configuration for local packages
        hydraJobs = import ./hydra { inherit self lib; };

        # Useful functions to use throughout the flake
        lib = import ./lib { inherit self; };

        # System modules for system consumption
        nixosModules = self.common.nixos-modules;

        # Home manager user definitions for system consumption
        homeManagerConfiguration = import ./users { inherit self; };

        # Home manager modules for user consumption
        homeManagerModules = self.common.home-manager-modules;

        options = self.outputs.lib.options.declarations;

        # Overlays for when stuff really doesn't fit in the round hole
        overlays = import ./overlays { inherit self; };

        schemas = (import ./schemas) // self.inputs.flake-schemas.schemas;

        # System configurations
        nixosConfigurations = import ./linux { inherit self; };
        darwinConfigurations = import ./darwin { inherit self; };
      };

      # Systems we want to wrap all outputs below in. This is split into 
      # two segments; those items inside the flake-utils block and those not.
      # The flake-utils block will automatically generate the <system>
      # sub-properties for all exposed elements as per: https://nixos.wiki/wiki/Flakes#Output_schema
      flake-utils-output = flake-utils.lib.eachDefaultSystem (system:
        let pkgs = import self.inputs.nixpkgs { inherit system; };
        in {
          # Space in which exposed derivations can be ran via
          # nix run .#foo - handy in the future for stuff like deploying
          # via terraform or automation tasks that are relatively 
          # procedural 
          apps = import ./apps { inherit self pkgs; };

          # Pre-commit hooks to enforce formatting, lining, find 
          # antipatterns and ensure they don't reach upstream
          checks = import ./checks { inherit self pkgs; };

          # Shell environments (applied to both nix develop and nix-shell via
          # shell.nix in top level directory)
          devShells = import ./shells { inherit self pkgs; };

          # Formatter option for `nix fmt` - redundant via checks but nice to have
          formatter = pkgs.nixfmt;

          # Locally defined packages for flake consumption or consumption
          # on the nur via: pkgs.nur.repos.JayRovacsek if utilising the nur overlay
          # (all systems in this flake apply this opinion via the common.modules)
          # construct
          packages = import ./packages { inherit self pkgs; };
        });

    in flake-utils-output // standard-outputs;
}
