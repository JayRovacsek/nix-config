{ self }:
let
  modules-function = import ../functions/modules.nix;

  inherit (self) inputs;

  # Package Sets
  inherit (inputs) stable;
  inherit (inputs) unstable;

  # Nix User Repositories
  inherit (inputs) nur;

  # Extra modules
  inherit (inputs) agenix;
  inherit (inputs) home-manager;
  inherit (inputs) microvm;
  inherit (inputs) nixos-generators;
  inherit (inputs) nixos-hardware;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  inherit (self.common) self-reference users home-manager-modules options;

  inherit (self.common.system) stable-system unstable-system;

  inherit (self.common.package-sets)
    x86_64-linux-stable x86_64-linux-unstable aarch64-linux-stable
    aarch64-linux-unstable;
in {
  alakazam = let
    inherit (x86_64-linux-unstable) system identifier;
    base = let base-modules = self.common.modules.${identifier};
    in base-modules;
    pkgs = x86_64-linux-unstable;
    modules = base ++ [
      ../hosts/alakazam
      microvm.nixosModules.host
      agenix.nixosModule
      nur.nixosModules.nur
    ];
  in unstable-system { inherit system pkgs modules; };

  gastly = let
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "gastly";
      extraModules = [ agenix.nixosModule self-reference ];
    };
  in unstable.lib.nixosSystem { inherit system pkgs modules; };

  dragonite = let
    inherit (x86_64-linux-stable) system;
    pkgs = x86_64-linux-stable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "dragonite";
      extraModules =
        [ microvm.nixosModules.host agenix.nixosModule self-reference ];
    };
  in stable.lib.nixosSystem { inherit system pkgs modules; };

  jigglypuff = let
    inherit (aarch64-linux-unstable) system;
    pkgs = aarch64-linux-unstable;
    modules = modules-function {
      inherit home-manager self;
      hostname = "jigglypuff";
      extraModules = [ agenix.nixosModule self-reference ];
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
        self-reference
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
      self-reference
    ];
  };

  aipom = unstable.lib.nixosSystem {
    inherit (x86_64-linux-unstable) system;
    pkgs = x86_64-linux-unstable;
    modules = [
      microvm.nixosModules.microvm
      ../hosts/aipom
      agenix.nixosModule
      self-reference
    ];
  };
}
