{
  description = "NixOS/Darwin configurations";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    my-overlays.url = "github:JayRovacsek/nix-overlays";

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
  };

  outputs = { self, nixpkgs, home-manager, nur, darwin, nixos-hardware
    , firefox-darwin, my-overlays, nixos-generators, microvm, ... }:
    let
      linuxOverlays = [ nur.overlay ];
      darwinOverlays =
        [ firefox-darwin.overlay nur.overlay my-overlays.dockutil ];
    in {
      nixosConfigurations = import ./linux/configurations.nix {
        inherit nixpkgs;
        inherit home-manager;
        extraModules = {
          inherit self;
          inherit nixos-hardware;
          inherit microvm;
          inherit nixos-generators;
        };
        overlays = linuxOverlays;
      };
      darwinConfigurations = import ./darwin/configurations.nix {
        inherit darwin;
        inherit nixpkgs;
        inherit home-manager;
        extraModules = { inherit nixos-hardware; };
        overlays = darwinOverlays;
      };
    };
}
