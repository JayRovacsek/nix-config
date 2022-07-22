{
  description = "NixOS/Darwin configurations";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-22.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    my-overlays = {
      url = "github:JayRovacsek/nix-overlays";
      inputs.nixpkgs.follows = "unstable";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "unstable";
    };

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "unstable";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "unstable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "unstable";
    };

    # This is required while https://github.com/ryantm/agenix/pull/107 is still open.
    # Note that this is only used for the OPTIONS and the main agenix package is utilised for
    # actual actions related to agenix
    agenix-darwin = {
      url = "github:cmhamill/agenix";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, darwin, nixos-hardware
    , firefox-darwin, my-overlays, nixos-generators, microvm, agenix
    , agenix-darwin, ... }:
    let
      allowMissingKernelModules = (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // { allowMissing = true; });
      });
      linuxOverlays = [ nur.overlay agenix.overlay allowMissingKernelModules ];
      darwinOverlays = [ firefox-darwin.overlay nur.overlay agenix.overlay ];
    in {
      nixosConfigurations = import ./linux/configurations.nix {
        inherit nixpkgs home-manager;
        extraModules = {
          inherit self nixos-hardware microvm nixos-generators agenix;
        };
        overlays = linuxOverlays;
      };

      darwinConfigurations = import ./darwin/configurations.nix {
        inherit darwin nixpkgs home-manager;
        extraModules = {
          inherit self nixos-hardware;
          agenix = agenix-darwin;
        };
        overlays = darwinOverlays;
      };
    };
}
