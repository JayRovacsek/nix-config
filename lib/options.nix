{ self }:
let
  inherit (self.lib) merge;
  inherit (self.inputs) home-manager nixpkgs nix-darwin;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (nix-darwin.lib) darwinSystem;
  inherit (home-manager.lib) homeManagerConfiguration;
  inherit (self.inputs.robotnix.lib) robotnixSystem;

  android-stub = robotnixSystem { };

  # System differences (options) between arch shouldn't exist, but
  # that's going to remain an assumption for now
  nix-stub = let system = "x86_64-linux";
  in nixosSystem {
    inherit system;
    pkgs = import nixpkgs { inherit system; };
    modules = [{
      imports = [
        ../options/flake
        ../options/hardware
        ../options/headscale
        ../options/networking
        ../options/nix
        ../options/ssh
        ../options/systemd
        ../options/tailscale
      ];
    }];
  };

  darwin-stub = let system = "x86_64-darwin";
  in darwinSystem {
    inherit system;
    pkgs = import nixpkgs { inherit system; };
    modules = [{
      imports = [
        ../options/blocky
        ../options/docker
        ../options/dockutil
        ../options/hardware
        ../options/headscale
        ../options/networking/darwin.nix
        ../options/nix
        ../options/ssh
      ];
    }];
  };

  home-manager-stub = let system = "x86_64-linux";
  in homeManagerConfiguration {
    pkgs = import nixpkgs { inherit system; };
    modules = [{
      home = {
        stateVersion = "23.11";
        username = "stub";
        homeDirectory = "/";
      };
    }];
  };

in {
  declarations = merge [
    android-stub.options
    darwin-stub.options
    home-manager-stub.options
    nix-stub.options
  ];
}
