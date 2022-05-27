{ nixpkgs, overlays, home-manager, extraModules ? { }, darwin ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;
  agenix = builtins.getAttr "agenix" extraModules;

  x86_64-darwin = import nixpkgs {
    system = "x86_64-darwin";
    inherit overlays;
    config = { allowUnfree = true; };
    extraModules = [ ];
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
      isLinux = false;
      extraModules =
        [ { nixpkgs.overlays = overlays; } agenix.nixosModules.age ];
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
      hostname = "ninetales";
      isLinux = false;
      extraModules = [{ nixpkgs.overlays = overlays; }];
    };
  in darwin.lib.darwinSystem {
    inherit system;
    inherit modules;
  };
}
