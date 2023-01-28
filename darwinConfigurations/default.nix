{ self }:
let
  inherit (self) inputs;

  # Package Sets
  inherit (self.inputs) stable unstable;

  # Extra modules
  inherit (self.inputs) agenix-darwin home-manager firefox-darwin nur;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  inherit (self.common) self-reference users home-manager-modules options;

  inherit (self.common.system) stable-darwin-system unstable-darwin-system;

  inherit (self.common.package-sets)
    aarch64-darwin-stable aarch64-darwin-unstable x86_64-darwin-stable
    x86_64-darwin-unstable;
in {
  # Hosts
  cloyster = let
    inherit (x86_64-darwin-stable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/cloyster agenix-darwin.nixosModules.age ];
  in stable-darwin-system { inherit system pkgs modules; };

  # cloyster = let
  #   inherit (x86_64-darwin-stable) system;
  #   modules = modules-function {
  #     inherit home-manager self;
  #     hostname = "cloyster";
  #     isLinux = false;
  #     extraModules =
  #       [ overlayModule agenix.nixosModules.age stableNix referenceSelf ];
  #   };
  # in darwin-stable.lib.darwinSystem { inherit system modules; };

  ninetales = let
    inherit (x86_64-darwin-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/ninetales agenix-darwin.nixosModules.age ];
  in unstable-darwin-system { inherit system pkgs modules; };

  # ninetales = let
  #   inherit (aarch64-darwin-unstable) system;
  #   pkgs = aarch64-darwin-unstable;
  #   modules = modules-function {
  #     inherit home-manager self;
  #     hostname = "ninetales";
  #     isLinux = false;
  #     extraModules =
  #       [ overlayModule agenix.nixosModules.age unstableNix referenceSelf ];
  #   };
  # in darwin-unstable.lib.darwinSystem { inherit system modules; };

  victreebel = let
    inherit (x86_64-darwin-stable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/victreebel agenix-darwin.nixosModules.age ];
  in stable-darwin-system { inherit system pkgs modules; };

  # victreebel = let
  #   inherit (aarch64-darwin-stable) system;
  #   modules = modules-function {
  #     inherit home-manager self;
  #     hostname = "victreebel";
  #     isLinux = false;
  #     extraModules =
  #       [ overlayModule agenix.nixosModules.age stableNix referenceSelf ];
  #   };
  # in darwin-stable.lib.darwinSystem { inherit system modules; };
}
