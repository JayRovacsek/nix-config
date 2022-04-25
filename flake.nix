{
  description = "NixOS/Darwin configurations";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "unstable";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    microvm.url = "github:astro/microvm.nix";
    firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    my-overlays.url = "github:JayRovacsek/nix-overlays";
  };

  outputs = { self, nixpkgs, home-manager, nur, darwin, nixos-hardware, microvm
    , firefox-darwin, my-overlays, ... }:
    let
      linuxOverlays = [ nur.overlay ];
      darwinOverlays =
        [ firefox-darwin.overlay nur.overlay my-overlays.dockutil ];
    in {
      nixosConfigurations = import ./linux/configurations.nix {
        inherit nixpkgs;
        inherit home-manager;
        inherit nixos-hardware;
        overlays = linuxOverlays;
      };
      darwinConfigurations = import ./darwin/configurations.nix {
        inherit darwin;
        inherit nixpkgs;
        inherit home-manager;
        inherit nixos-hardware;
        overlays = darwinOverlays;
      };
    };
}
