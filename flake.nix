{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, nur, ... }:
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

        # work machine, needs a lot of _work_ ba-doom-tish.gif
        device = nixpkgs.lib.nixosSystem {
          system = "x86_64-darwin";
          pkgs = import nixpkgs {
            system = "x86_64-darwin";
            config = { allowUnfree = true; };
            overlays = [ nur.overlay ];
          };
          modules = [
            ./hosts/device
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = import ./packages/darwin-x86.nix;
            }
          ];
        };
      };
    };
}
