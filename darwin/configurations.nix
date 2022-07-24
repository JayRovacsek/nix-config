{ nixpkgs, overlays, home-manager, extraModules ? { }, darwin ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;
  agenix = builtins.getAttr "agenix" extraModules;
  self = builtins.getAttr "self" extraModules;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  referenceSelf = { config._module.args.flake = self; };

  x86_64-darwin = import nixpkgs {
    system = "x86_64-darwin";
    inherit overlays;
    config = { allowUnfree = true; };
    extraModules = [ referenceSelf ];
  };

  aarch64-darwin = import nixpkgs {
    system = "aarch64-darwin";
    inherit overlays;
    config = { allowUnfree = true; };
    extraModules = [ referenceSelf ];
  };
in {
  cloyster = let
    system = x86_64-darwin.system;
    pkgs = x86_64-darwin;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "cloyster";
      isLinux = false;
      extraModules =
        [ { nixpkgs.overlays = overlays; } agenix.nixosModules.age ];
    };
  in darwin.lib.darwinSystem { inherit system modules; };

  ninetales = let
    system = aarch64-darwin.system;
    pkgs = aarch64-darwin;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "ninetales";
      isLinux = false;
      extraModules =
        [ { nixpkgs.overlays = overlays; } agenix.nixosModules.age ];
    };
  in darwin.lib.darwinSystem { inherit system modules; };
}
