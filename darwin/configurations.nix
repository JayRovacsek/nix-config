{ self }:
let
  modules-function = import ../functions/modules.nix;

  flake = self;
  inputs = self.inputs;

  # Package Sets
  nixpkgs = inputs.stable;
  nixpkgs-unstable = inputs.unstable;

  # Extra modules
  agenix = inputs.agenix-darwin;
  darwin-stable = inputs.darwin-stable;
  darwin-unstable = inputs.darwin-unstable;
  firefox = inputs.firefox-darwin;
  home-manager = inputs.home-manager;
  nur = inputs.nur;

  # This is required for any system needing to reference the flake itself from
  # within the config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  referenceSelf = { config._module.args.flake = self; };

  standardiseNix = { stable ? false }: {
    environment.etc."nix/inputs/nixpkgs".source =
      if stable then nixpkgs.outPath else nixpkgs-unstable.outPath;
    nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
  };

  localOverlays = import ../overlays;
  overlays = [ agenix.overlay firefox.overlay localOverlays nur.overlay ];

  aarch64-darwin-stable = import nixpkgs {
    system = "aarch64-darwin";
    inherit overlays;
  };

  aarch64-darwin-unstable = import nixpkgs-unstable {
    system = "aarch64-darwin";
    inherit overlays;
  };

  x86_64-darwin-stable = import nixpkgs {
    system = "x86_64-darwin";
    inherit overlays;
  };

  x86_64-darwin-unstable = import nixpkgs-unstable {
    system = "x86_64-darwin";
    inherit overlays;
  };

  overlayModule = { nixpkgs = { inherit overlays; }; };

in {
  cloyster = let
    inherit (x86_64-darwin-unstable) system;
    modules = modules-function {
      inherit home-manager self;
      hostname = "cloyster";
      isLinux = false;
      extraModules = [
        overlayModule
        agenix.nixosModules.age
        (standardiseNix { })
        referenceSelf
      ];
    };
  in darwin-unstable.lib.darwinSystem { inherit system modules; };

  ninetales = let
    inherit (aarch64-darwin-unstable) system;
    pkgs = aarch64-darwin-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "ninetales";
      isLinux = false;
      extraModules = [
        overlayModule
        agenix.nixosModules.age
        (standardiseNix { })
        referenceSelf
      ];
    };
  in darwin-unstable.lib.darwinSystem { inherit system modules; };
}
