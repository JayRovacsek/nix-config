{
  description = "NixOS/Darwin configurations";

  inputs = {
    # Kept only temporarily until no longer utilised
    "22-05".url = "github:nixos/nixpkgs/release-22.05";

    # Stable / Unstable split in packages
    stable.url = "github:nixos/nixpkgs/release-22.11";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl = {
      url =
        "github:nix-community/NixOS-WSL/3721fe7c056e18c4ded6c405dbee719692a4528a";
      inputs = {
        nixpkgs.follows = "stable";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
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
      inputs.nixpkgs.follows = "unstable";
      url = "github:lnl7/nix-darwin/master";
    };

    # Adds flake compatability to start removing the vestiges of 
    # shell.nix and move us towards the more modern nix develop
    # setting while tricking some services/plugins to still be able to
    # use the shell.nix file.
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Adds configurable pre-commit options to our flake :)
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "stable";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    # This is required while https://github.com/ryantm/agenix/pull/107 is still open.
    # Note that this is only used for the OPTIONS and the main agenix package is utilised for
    # actual actions related to agenix
    agenix-darwin = {
      url = "github:cmhamill/agenix";
      inputs.nixpkgs.follows = "stable";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "stable";
    };

    # Simply required for sane management of Firefox on darwin
    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "unstable";
    };

    # Home management module
    home-manager = {
      url = "github:rycee/home-manager/release-22.11";
      inputs.nixpkgs.follows = "stable";
    };

    # Microvm module, PoC state for implementation
    microvm = {
      url = "github:astro/microvm.nix";
      inputs = {
        nixpkgs.follows = "stable";
        flake-utils.follows = "flake-utils";
      };
    };

    # Generate system images easily
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "stable";
    };

    # Apply opinions on hardware that are driven by community
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Like the Arch User Repository, but better :)
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, flake-utils, ... }:
    let
      # Systems we want to wrap all outputs below in. This is split into 
      # two segments; those items inside the flake-utils block and those not.
      # The flake-utils block will automatically generate the <system>
      # sub-properties for all exposed elements as per: https://nixos.wiki/wiki/Flakes#Output_schema
      exposedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
    in flake-utils.lib.eachSystem exposedSystems (system: {
      checks = import ./checks { inherit self system; };
      devShells = import ./devShells { inherit self system; };
      formatter = self.inputs.stable.legacyPackages.${system}.nixfmt;
      packages = import ./packages { inherit self system; };
    }) // {
      inherit exposedSystems;

      lib = import ./lib { inherit self; };
      common = import ./common { inherit self; };
      overlays = import ./overlays { inherit self; };
      nixosConfigurations = import ./nixosConfigurations { inherit self; };
      darwinConfigurations = import ./darwinConfigurations { inherit self; };
    };
}
