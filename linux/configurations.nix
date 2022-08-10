{ nixpkgs, overlays, home-manager, extraModules ? { }, darwin ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;

  self = builtins.getAttr "self" extraModules;
  agenix = builtins.getAttr "agenix" extraModules;
  nixos-hardware = builtins.getAttr "nixos-hardware" extraModules;
  microvm = builtins.getAttr "microvm" extraModules;
  nixos-generators = builtins.getAttr "nixos-generators" extraModules;
  standardiseNix = builtins.getAttr "standardiseNix" extraModules;

  # This is required for any system needing to reference the flake itself from
  # within the nixosSystem config. It will be available as an argument to the 
  # config as "flake" if used as defined below
  referenceSelf = { config._module.args.flake = self; };

  x86_64-linux = microvm.packages.x86_64-linux // import nixpkgs {
    system = "x86_64-linux";
    inherit overlays;
    config = { allowUnfree = true; };
  };

  aarch64-linux = import nixpkgs {
    system = "aarch64-linux";
    inherit overlays;
    config = { allowUnfree = true; };
  };

in {
  alakazam = let
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "alakazam";
      extraModules =
        [ microvm.nixosModules.host agenix.nixosModule referenceSelf ];
    } ++ standardiseNix;
  in nixpkgs.lib.nixosSystem { inherit system pkgs modules; };

  gastly = let
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "gastly";
      extraModules = [ agenix.nixosModule referenceSelf ];
    } ++ standardiseNix;
  in nixpkgs.lib.nixosSystem { inherit system pkgs modules; };

  dragonite = let
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "dragonite";
      extraModules =
        [ microvm.nixosModules.host agenix.nixosModule referenceSelf ];
    } ++ standardiseNix;
  in nixpkgs.lib.nixosSystem { inherit system pkgs modules; };

  # Dead for now. RIP M1
  # ninetales = let
  #   system = aarch64-linux.system;
  #   pkgs = aarch64-linux;
  #   modules = home-manager-function {
  #     inherit home-manager self;
  #     hostname = "ninetales";
  #     extraModules = [ agenix.nixosModule ];
  #   } ++ standardiseNix;
  # in nixpkgs.lib.nixosSystem { inherit system pkgs modules; };

  jigglypuff = let
    system = aarch64-linux.system;
    pkgs = aarch64-linux;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "jigglypuff";
      extraModules = [ agenix.nixosModule referenceSelf ];
    } ++ standardiseNix;
  in nixpkgs.lib.nixosSystem { inherit system pkgs modules; };

  wigglytuff = let
    system = aarch64-linux.system;
    pkgs = aarch64-linux;
    modules = home-manager-function {
      inherit home-manager self;
      hostname = "wigglytuff";
      extraModules = [
        nixos-hardware.nixosModules.raspberry-pi-4
        agenix.nixosModule
        referenceSelf
      ];
    } ++ standardiseNix;
  in nixpkgs.lib.nixosSystem { inherit system pkgs modules; };

  ## MICROVMS

  igglybuff = nixpkgs.lib.nixosSystem {
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = [
      microvm.nixosModules.microvm
      ../hosts/igglybuff
      agenix.nixosModule
      referenceSelf
    ] ++ standardiseNix;
  };

  aipom = nixpkgs.lib.nixosSystem {
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = [
      microvm.nixosModules.microvm
      ../hosts/aipom
      agenix.nixosModule
      referenceSelf
    ] ++ standardiseNix;
  };
}
