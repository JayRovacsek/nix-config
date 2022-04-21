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
  };

  outputs = { self, nixpkgs, home-manager, nur, darwin, nixos-hardware, microvm
    , firefox-darwin, ... }:
    let
      home-manager-function = import ./functions/home-manager.nix;
      overlays = [ nur.overlay ];
      x86-linux-pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
        config = { allowUnfree = true; };
      };
      x86-darwin-pkgs = import nixpkgs {
        system = "x86_64-darwin";
        inherit overlays;
        config = { allowUnfree = true; };
      };
    in {
      nixosConfigurations = {
        alakazam = let
          system = x86-linux-pkgs.system;
          pkgs = x86-linux-pkgs;
          modules = home-manager-function {
            inherit home-manager;
            host = "alakazam";
            isNixos = true;
          };
        in nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          inherit modules;
        };

        gastly = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
            overlays = [ nur.overlay ];
          };
          modules = [
            ./hosts/gastly
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = { pkgs, ... }: {
                imports = [
                  ./modules/home-manager/dconf.nix
                  ./packages/x86_64-linux.nix
                ];
              };
            }
          ];
        };

        dragonite = let
          system = "x86_64-linux";
          overlays = [ nur.overlay ];
          pkgs = import nixpkgs {
            inherit system;
            inherit overlays;
            config = { allowUnfree = true; };
          };
        in nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          modules = [ ./hosts/dragonite ];
        };

        ninetales = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config = { allowUnfree = true; };
            overlays = [ nur.overlay ];
          };
          modules = [
            ./hosts/ninetales
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = { pkgs, ... }: {
                imports = [ ./packages/aarch64-linux.nix ];
              };
            }
          ];
        };

        jigglypuff = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            config = { allowUnfree = true; };
            overlays = [ nur.overlay ];
          };
          modules = [
            ./hosts/jigglypuff
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = { pkgs, ... }: {
                imports = [ ./packages/aarch64-linux-minimal.nix ];
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
          modules = [
            ./hosts/wigglytuff
            nixos-hardware.nixosModules.raspberry-pi-4
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jay = { pkgs, ... }: {
                imports = [ ./packages/aarch64-linux.nix ];
              };
            }
          ];
        };
      };

      darwinConfigurations = let system = "x86_64-darwin";
      in rec {
        cloyster = let
          modules = home-manager-function {
            inherit home-manager;
            host = "cloyster";
            isNixos = false;
          };
        in darwin.lib.darwinSystem {
          inherit system;
          modules = modules
            ++ [{ nixpkgs.overlays = [ firefox-darwin.overlay nur.overlay ]; }];
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
                import ./packages/x86_64-darwin-minimal.nix;
            }
          ];
        };
      };
    };
}
