{ self }:
let
  inherit (self.lib) merge;
  inherit (self.inputs) home-manager nixpkgs nix-darwin;
  inherit (nixpkgs.lib) nixosSystem;
  inherit (nix-darwin.lib) darwinSystem;
  inherit (home-manager.lib) homeManagerConfiguration;

  # System differences (options) between arch shouldn't exist, but
  # that's going to remain an assumption for now
  nix-stub = let system = "x86_64-linux";
  in nixosSystem {
    inherit system;
    pkgs = import nixpkgs { inherit system; };
    modules = [{
      system.stateVersion = "24.05";

      imports = [
        ../options/flake
        ../options/hardware
        ../options/headscale
        ../options/networking
        ../options/nix
        ../options/systemd
      ];
    }];
  };

  darwin-stub = let system = "x86_64-darwin";
  in darwinSystem {
    inherit system;
    pkgs = import nixpkgs { inherit system; };
    modules = [{
      system.stateVersion = "24.05";

      imports = [
        ../options/blocky
        ../options/docker
        ../options/dockutil
        ../options/hardware
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
        enableNixpkgsReleaseCheck = false;
        homeDirectory = "/";
        stateVersion = "23.11";
        username = "stub";
      };
    }];
    extraSpecialArgs = { inherit self; };
  };

in {
  declarations =
    merge [ nix-stub.options darwin-stub.options home-manager-stub.options ];
}
