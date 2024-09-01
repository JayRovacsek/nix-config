{ self }:
let
  inherit (self.lib) merge;
  inherit (self.inputs) home-manager nixpkgs nix-darwin;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (nix-darwin.lib) darwinSystem;
  inherit (home-manager.lib) homeManagerConfiguration;

  # System differences (options) between arch shouldn't exist, but
  # that's going to remain an assumption for now
  nix-stub =
    let
      system = "x86_64-linux";
    in
    nixosSystem {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
      modules = [
        self.common.options.x86_64-linux-unstable.minimal
        {
          system.stateVersion = "24.05";
        }
      ];
    };

  darwin-stub =
    let
      system = "x86_64-darwin";
    in
    darwinSystem {
      inherit system;
      pkgs = import nixpkgs { inherit system; };
      modules = [
        self.common.options.x86_64-darwin-unstable.minimal
        {
          system.stateVersion = "24.05";
        }
      ];
    };

  darwin-home-manager-stub =
    let
      system = "x86_64-darwin";
    in
    homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        self.common.options.x86_64-darwin-unstable.all-home-manager-modules
        {
          home = {
            enableNixpkgsReleaseCheck = false;
            homeDirectory = "/";
            stateVersion = "23.11";
            username = "stub";
          };
        }
      ];
      extraSpecialArgs = {
        inherit self;
      };
    };

  linux-home-manager-stub =
    let
      system = "x86_64-linux";
    in
    homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        self.common.options.x86_64-linux-unstable.all-home-manager-modules
        {
          home = {
            enableNixpkgsReleaseCheck = false;
            homeDirectory = "/";
            stateVersion = "23.11";
            username = "stub";
          };
        }
      ];
      extraSpecialArgs = {
        inherit self;
      };
    };

in
{
  declarations = merge [
    darwin-home-manager-stub.options
    darwin-stub.options
    linux-home-manager-stub.options
    nix-stub.options
  ];
}
