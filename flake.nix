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
  };

  outputs =
    { self, nixpkgs, home-manager, nur, darwin, nixos-hardware, ... }@inputs: {
      nixosConfigurations = {
        alakazam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
            overlays = [ nur.overlay ];
          };
          modules = [
            ./hosts/alakazam
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = { pkgs, ... }: {
                imports =
                  [ ./modules/home-manager/dconf.nix ./packages/linux-x86.nix ];
              };
            }
          ];
        };

        wigglytuff = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config = { allowUnfree = true; };
            overlays = [ nur.overlay ];
          };
          modules =
            [ ./hosts/wigglytuff nixos-hardware.nixosModules.raspberry-pi-4 ];
        };
      };

      darwinConfigurations = {
        cloyster = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./hosts/cloyster
            home-manager.darwinModule
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jrovacsek = import ./packages/darwin-x86.nix;
            }
          ];
        };
        ninetales = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./hosts/ninetales
            home-manager.darwinModule
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jrovacsek =
                import ./packages/darwin-x86-minimal.nix;
            }
          ];
        };
      };
    };
}
