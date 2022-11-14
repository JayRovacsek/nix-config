{ self }:
let
  modules-function = import ../functions/modules.nix;

  inputs = self.inputs;

  # Package Sets
  stable = inputs.stable;
  nixpkgs = inputs.stable;
  unstable = inputs.unstable;
  nixpkgs-unstable = inputs.unstable;

  # Nix User Repositories
  nur = inputs.nur;

  # Pull recusrive update out to use it later
  inherit (stable.lib) recursiveUpdate;

  # Extra modules
  agenix = inputs.agenix;
  home-manager = inputs.home-manager;
  microvm = inputs.microvm;
  nixos-generators = inputs.nixos-generators;
  nixos-hardware = inputs.nixos-hardware;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  referenceSelf = { config._module.args.flake = self; };

  # A function to apply opinions on the nixpkgs pinning of a system.
  # Absolutely required for repoducability
  standardiseNix = { stable ? false }: {
    environment.etc."nix/inputs/nixpkgs".source =
      if stable then nixpkgs.outPath else nixpkgs-unstable.outPath;
    nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
  };

  # Stable / unstable splits of the above function so we can reduce complexity in each nixosConfiguration call below
  stableNix = standardiseNix { stable = true; };
  unstableNix = standardiseNix { };

  # Load local overlays and merge with upstream options
  localOverlays = import ../overlays;
  overlays = [ nur.overlay agenix.overlay localOverlays ];

  x86_64-linux-stable = recursiveUpdate (import nixpkgs {
    system = "x86_64-linux";
    inherit overlays;
    config = { allowUnfree = true; };
  }) microvm.packages.x86_64-linux;

  x86_64-linux-unstable = recursiveUpdate (import nixpkgs-unstable {
    system = "x86_64-linux";
    inherit overlays;
    config = { allowUnfree = true; };
  }) microvm.packages.x86_64-linux;

  aarch64-linux-stable = recursiveUpdate (import nixpkgs {
    system = "aarch64-linux";
    inherit overlays;
    config = { allowUnfree = true; };
  }) microvm.packages.aarch64-linux;

  aarch64-linux-unstable = recursiveUpdate (import nixpkgs-unstable {
    system = "aarch64-linux";
    inherit overlays;
    config = { allowUnfree = true; };
  }) microvm.packages.aarch64-linux;
in {
  alakazam = let
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "alakazam";
      extraModules = [
        microvm.nixosModules.host
        agenix.nixosModule
        referenceSelf
        nur.nixosModules.nur
        unstableNix
      ];
    };
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  gastly = let
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "gastly";
      extraModules = [ agenix.nixosModule referenceSelf unstableNix ];
    };
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  dragonite = let
    inherit (x86_64-linux-stable) system;
    pkgs = x86_64-linux-stable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "dragonite";
      extraModules = [
        microvm.nixosModules.host
        agenix.nixosModule
        referenceSelf
        stableNix
      ];
    };
  in stable.lib.nixosSystem { inherit system pkgs modules; };

  jigglypuff = let
    inherit (aarch64-linux-unstable) system;
    pkgs = aarch64-linux-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "jigglypuff";
      extraModules = [ agenix.nixosModule referenceSelf unstableNix ];
    };
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  wigglytuff = let
    inherit (aarch64-linux-unstable) system;
    pkgs = aarch64-linux-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "wigglytuff";
      extraModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
        agenix.nixosModule
        referenceSelf
        unstableNix
      ];
    };
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  ## MICROVMS

  igglybuff = unstable.lib.nixosSystem {
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = [
      microvm.nixosModules.microvm
      ../hosts/igglybuff
      agenix.nixosModule
      referenceSelf
      unstableNix
    ];
  };

  aipom = unstable.lib.nixosSystem {
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = [
      microvm.nixosModules.microvm
      ../hosts/aipom
      agenix.nixosModule
      referenceSelf
      unstableNix
    ];
  };
}
