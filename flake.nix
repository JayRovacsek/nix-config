{
  description = "NixOS/Darwin configurations";

  inputs = {
    # Stable / Unstable split in packages
    stable.url = "github:nixos/nixpkgs/release-23.05";
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

    # We need to wrap darwin as it exposes darwin.lib.darwinSystem
    # therefore we can't depend on stable/unstable to handle the correct matching
    # of stable/unstable to make a suitable decision per system
    darwin-stable = {
      inputs.nixpkgs.follows = "stable";
      url = "github:lnl7/nix-darwin/master";
    };
    darwin-unstable = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:lnl7/nix-darwin/master";
    };

    # Simply required for sane management of Firefox on darwin
    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Adds flake compatibility to start removing the vestiges of 
    # shell.nix and move us towards the more modern nix develop
    # setting while tricking some services/plugins to still be able to
    # use the shell.nix file.
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";

    flake-parts.url = "github:hercules-ci/flake-parts";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hercules-ci-agent = {
      url = "github:hercules-ci/hercules-ci-agent";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        hercules-ci-agent.follows = "hercules-ci-agent";
      };
    };

    # Home management module
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wayland compositor & WM
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        hyprland-protocols.follows = "hyprland-protocols";
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules to help you handle persistent state on systems with ephemeral root storage.
    impermanence.url = "github:nix-community/impermanence";

    lib-aggregate = {
      url = "github:nix-community/lib-aggregate";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Microvm module, PoC state for implementation
    microvm = {
      url = "github:astro/microvm.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    neovim-flake = {
      url = "github:notashelf/neovim-flake";
      inputs = {
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixci = {
      url = "github:srid/nixci";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixified-ai = {
      url = "github:nixified-ai/flake";
      inputs = {
        flake-parts.follows = "flake-parts";
        hercules-ci-effects.follows = "hercules-ci-effects";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixinate = {
      url = "github:matthewcroughan/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Generate system images easily
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apply opinions on hardware that are driven by community
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixos modules to be used in the Windows Subsystem for Linux  
    nixos-wsl = {
      url =
        "github:nix-community/NixOS-WSL/3721fe7c056e18c4ded6c405dbee719692a4528a";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs = {
        flake-compat.follows = "flake-compat";
        lib-aggregate.follows = "lib-aggregate";
        nix-eval-jobs.follows = "nix-eval-jobs";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-eval-jobs = {
      url = "github:nix-community/nix-eval-jobs";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Like the Arch User Repository, but better :)
    nur.url = "github:nix-community/NUR";

    # Adds configurable pre-commit options to our flake :)
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        gitignore.follows = "gitignore";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Software bill of materials package
    sbomnix = {
      url = "github:tiiuae/sbomnix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Software bill of materials package
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        flake-compat.follows = "flake-compat";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Terraform via the nix language
    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs = {
        hyprland-protocols.follows = "hyprland-protocols";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, flake-utils, ... }:
    let
      inherit (self.inputs.nixpkgs.lib) recursiveUpdate;

      standard-outputs = {
        # Common/consistent values to be consumed by the flake
        common = import ./common { inherit self; };

        # Useful functions to use throughout the flake
        lib = import ./lib { inherit self; };

        # Overlays for when stuff really doesn't fit in the round hole
        overlays = import ./overlays { inherit self; };

        # System modules for system consumption
        nixosModules = builtins.foldl' (accumulator: module:
          recursiveUpdate {
            ${module} =
              { config, pkgs, lib, options, specialArgs, modulesPath }:
              import ./modules/${module} {
                inherit config pkgs lib options specialArgs modulesPath;
              };
          } accumulator) { } self.common.nixos-modules;

        # System configurations
        nixosConfigurations = import ./linux { inherit self; };
        darwinConfigurations = import ./darwin { inherit self; };
      };

      # Systems we want to wrap all outputs below in. This is split into 
      # two segments; those items inside the flake-utils block and those not.
      # The flake-utils block will automatically generate the <system>
      # sub-properties for all exposed elements as per: https://nixos.wiki/wiki/Flakes#Output_schema
      flake-utils-output =
        flake-utils.lib.eachSystem standard-outputs.common.exposed-systems
        (system: {
          # Space in which exposed derivations can be ran via
          # nix run .#foo - handy in the future for stuff like deploying
          # via terraform or automation tasks that are relatively 
          # procedural 
          apps = import ./apps { inherit self system; };

          # Pre-commit hooks to enforce formatting, lining, find 
          # antipatterns and ensure they don't reach upstream
          checks = import ./checks { inherit self system; };

          # Shell environments (applied to both nix develop and nix-shell via
          # shell.nix in top level directory)
          devShells = import ./shells { inherit self system; };

          # Formatter option for `nix fmt` - redundant via checks but nice to have
          formatter = self.inputs.nixpkgs.legacyPackages.${system}.nixfmt;

          # Locally defined packages for flake consumption or consumption
          # on the nur via: pkgs.nur.repos.JayRovacsek if utilising the nur overlay
          # (all systems in this flake apply this opinion via the common.modules)
          # construct
          packages = import ./packages {
            inherit self system;
            pkgs = self.inputs.nixpkgs.legacyPackages.${system};
          };
        });

    in flake-utils-output // standard-outputs;
}
