{
  description = "NixOS/Darwin configurations";

  inputs = {
    # stable.url = "github:nixos/nixpkgs/release-22.05";
    "22-05".url = "github:nixos/nixpkgs/release-22.05";
    stable.url = "github:nixos/nixpkgs/release-22.11";
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
    agenix-darwin = {
      url = "github:cmhamill/agenix";
      inputs.nixpkgs.follows = "stable";
    };

    # Assuming we have a standardised and flake managed nixpkgs / channel setup
    # we don't need to set the below as they'll self-correct after a second rebuild
    # when first shifting to the new structure
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "stable";
    };
    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:rycee/home-manager/release-22.11";
      inputs.nixpkgs.follows = "stable";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "stable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "stable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    # Required for default toolchain changes
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "stable";
    };
  };

  outputs = { self, flake-utils, ... }:
    let
      lib = import ./lib { inherit self; };
      common = import ./common { inherit self; };
      exposedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      pre-commit-unsupported = [ "armv6l-linux" "armv7l-linux" ];
      # The below sets a dev shell for the flake with inputs defined in 
      # the packags section of the dev shell and shellHook running on 
      # evaluation by direnv
    in flake-utils.lib.eachSystem exposedSystems (system:
      let
        # Note that the below use of pkgs will by implication mean that
        # our dev dependencies for local packages as well as part of our
        # devShell are pinned to stable - this is intended to ensure
        # backwards compatability & reduced pain when managing deps
        # in these spaces
        pkgs = self.inputs.stable.legacyPackages.${system};
        pkgsUnstable = self.inputs.unstable.legacyPackages.${system};

        checks = if builtins.elem system pre-commit-unsupported then
          { }
        else {
          pre-commit-check = self.inputs.pre-commit-hooks.lib.${system}.run
            (import ./pre-commit-checks.nix { inherit self pkgs system; });
        };

        shell-base = let packages = with pkgs; [ nixfmt statix vulnix nil ];
        in {
          name = "nix-config-dev-shell";
          inherit packages;
        };

        shell = (let packages = with pkgs; [ nixfmt statix vulnix nil ];
        in if builtins.elem system pre-commit-unsupported then
          { }
        else {
          # Self reference to make the default shell hook that which generates
          # a suitable pre-commit hook installation
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        }) // shell-base;

        # Little bit of hackery above given not many things are supported on armv6 or armv7
        # so we remove pre-commit checks on these systems.
        devShell = pkgs.mkShell shell;

        # Self reference the dev shell for our system to resolve the lacking
        # devShells.${system}.default recommended structure
        devShells.default = self.outputs.devShell.${system};

        formatter = pkgs.nixfmt;
        packages = self.outputs.common.images;

      in {
        inherit devShell devShells checks formatter packages;
        # Normally the // pattern is a little frowned upon as it does not act
        # the way most people expect - here it's fine as we've got two sets that have no 
        # collision space:
        # { devShell } + { nixosConfigurations: { ... }, darwinConfigurations: { ... }  }
      }) // {
        inherit lib common exposedSystems;
        nixosConfigurations =
          import ./linux/configurations.nix { inherit self; };
        darwinConfigurations =
          import ./darwin/configurations.nix { inherit self; };
      };
}
