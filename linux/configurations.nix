{ self }:
let
  modules-function = import ../functions/modules.nix;

  inherit (self) inputs;

  # Package Sets
  inherit (inputs) stable;
  nixpkgs = inputs.stable;
  inherit (inputs) unstable;
  nixpkgs-unstable = inputs.unstable;

  # Nix User Repositories
  inherit (inputs) nur;

  # Pull recusrive update out to use it later
  inherit (stable.lib) recursiveUpdate;

  # Extra modules
  inherit (inputs) agenix;
  inherit (inputs) home-manager;
  inherit (inputs) microvm;
  inherit (inputs) nixos-generators;
  inherit (inputs) nixos-hardware;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  flake = self;
  referenceSelf = { config._module.args = { inherit flake; }; };

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

  inherit (flake.common) users home-manager-modules;
  inherit (flake.lib) generate-user-config;
  jay = users.jay {
    pkgs = x86_64-linux-unstable;
    home-manager-modules = with home-manager-modules; [ bat ];
  };

in {
  alakazam = let
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = [
      ../hosts/alakazam
      jay
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
      microvm.nixosModules.host
      agenix.nixosModule
      referenceSelf
      nur.nixosModules.nur
      unstableNix
    ];
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
