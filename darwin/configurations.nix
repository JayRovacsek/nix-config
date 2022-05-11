{ nixpkgs, overlays, home-manager, nixos-hardware ? { }, darwin ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;

  x86_64-darwin = import nixpkgs {
    system = "x86_64-darwin";
    inherit overlays;
    config = { allowUnfree = true; };
  };

  aarch64-darwin = import nixpkgs {
    system = "aarch64-darwin";
    inherit overlays;
    config = { allowUnfree = true; };
  };
in {
  cloyster = let
    system = x86_64-darwin.system;
    pkgs = x86_64-darwin;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "cloyster";
      isNixos = false;
      extraModules = [{ nixpkgs.overlays = overlays; }];
    };
  in darwin.lib.darwinSystem {
    inherit system;
    inherit modules;
  };

  ninetales = let
    system = aarch64-darwin.system;
    pkgs = aarch64-darwin;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "aarch64-ninetales";
      isNixos = false;
      extraModules = [{ nixpkgs.overlays = overlays; }];
    };
  in darwin.lib.darwinSystem {
    inherit system;
    inherit modules;
  };
}
