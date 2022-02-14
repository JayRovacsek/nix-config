{
  description = "NixOS/Darwin configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nur, darwin, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [ nur.overlay ];
      };
    in {
      nixosConfigurations = {
        alakazam = nixpkgs.lib.nixosSystem {
          inherit pkgs system;
          modules = [
            ./hosts/alakazam
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = import ./packages/linux-x86.nix;
            }
          ];
        };
      };

      darwinConfigurations = {
        cloyster = darwin.lib.darwinSystem {
          inherit pkgs;
          system = "x86_64-darwin";
          modules = [
            ./hosts/cloyster
            home-manager.darwinModule
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jrovacsek = import ./packages/darwin_x86.nix;
            }
          ];
        };
      };
    };
}
