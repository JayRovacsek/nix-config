{
  description = "NixOS/Darwin configurations";

  inputs = {
    stable.url = "github:nixos/nixpkgs/release-22.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
      };
    };

    # This is required while https://github.com/ryantm/agenix/pull/107 is still open.
    # Note that this is only used for the OPTIONS and the main agenix package is utilised for
    # actual actions related to agenix
    agenix-darwin.url = "github:cmhamill/agenix";

    # Assuming we have a standardised and flake managed nixpkgs / channel setup
    # we don't need to set the below as they'll self-correct after a second rebuild
    # when first shifting to the new structure
    agenix.url = "github:ryantm/agenix";
    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:rycee/home-manager/release-22.05";
    microvm.url = "github:astro/microvm.nix";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    # Required for default toolchain changes
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, flake-utils, ... }:
    # The below sets a dev shell for the flake with inputs defined in 
    # the packags section of the dev shell and shellHook running on 
    # evaluation by direnv
    flake-utils.lib.eachSystem [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system:
      let
        # Note that the below use of pkgs will by implication mean that
        # our dev dependencies for local packages as well as part of our
        # devShell are pinned to stable - this is intended to ensure
        # backwards compatability & reduced pain when managing deps
        # in these spaces
        pkgs = self.inputs.stable.legacyPackages.${system};
        pkgsUnstable = self.inputs.unstable.legacyPackages.${system};

        devShellStableDeps = with pkgs; [ nixfmt statix vulnix ];
        devShellUnstableDeps = with pkgsUnstable; [ nil ];

        checks = {
          pre-commit-check = self.inputs.pre-commit-hooks.lib.${system}.run
            (import ./pre-commit-checks.nix { inherit self pkgs system; });
        };

        devShell = pkgs.mkShell {
          name = "nix-config-dev-shell";
          packages = devShellStableDeps ++ devShellUnstableDeps;
          # Self reference to make the default shell hook that which generates
          # a suitable pre-commit hook installation
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };

        # Self reference the dev shell for our system to resolve the lacking
        # devShells.${system}.default recommended structure
        devShells.default = self.outputs.devShell.${system};

        # Import local packages passing system relevnet pkgs through
        # for dependencies.
        localPackages = import ./packages { inherit pkgs; };
        localUnstablePackages =
          import ./packages/unstable.nix { pkgs = pkgsUnstable; };
        packages = flake-utils.lib.flattenTree localPackages;
        unstablePackages = flake-utils.lib.flattenTree localUnstablePackages;
      in {
        inherit devShell devShells packages unstablePackages checks;
        # Normally the // pattern is a little frowned upon as it does not act
        # the way most people expect - here it's fine as we've got two sets that have no 
        # collision space:
        # { devShell } + { nixosConfigurations: { ... }, darwinConfigurations: { ... }  }
      }) // {
        nixosConfigurations =
          import ./linux/configurations.nix { inherit self; };
        darwinConfigurations =
          import ./darwin/configurations.nix { inherit self; };
      };
}
