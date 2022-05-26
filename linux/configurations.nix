{ nixpkgs, overlays, home-manager, extraModules ? { }, darwin ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;

  self = builtins.getAttr "self" extraModules;
  agenix = builtins.getAttr "agenix" extraModules;
  nixos-hardware = builtins.getAttr "nixos-hardware" extraModules;
  microvm = builtins.getAttr "microvm" extraModules;
  nixos-generators = builtins.getAttr "nixos-generators" extraModules;

  x86_64-linux = import nixpkgs {
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
      inherit home-manager;
      hostname = "alakazam";
      extraModules = [
        microvm.nixosModules.host
        # ({ microvm.vms.igglybuff.flake = self; })
        agenix.nixosModule
      ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };

  gastly = let
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "gastly";
      extraModules = [ agenix.nixosModule ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };

  dragonite = let
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "dragonite";
      extraModules = [ agenix.nixosModule ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };

  ninetales = let
    system = aarch64-linux.system;
    pkgs = aarch64-linux;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "ninetales";
      extraModules = [ agenix.nixosModule ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };

  jigglypuff = let
    system = aarch64-linux.system;
    pkgs = aarch64-linux;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "jigglypuff";
      extraModules = [ agenix.nixosModule ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };

  wigglytuff = let
    system = aarch64-linux.system;
    pkgs = aarch64-linux;
    modules = home-manager-function {
      inherit home-manager;
      hostname = "wigglytuff";
      extraModules =
        [ nixos-hardware.nixosModules.raspberry-pi-4 agenix.nixosModule ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };

  igglybuff = nixpkgs.lib.nixosSystem {
    system = x86_64-linux.system;
    pkgs = x86_64-linux;
    modules = [ microvm.nixosModules.microvm ../microvms/dns.nix ];
  };

  # packages.x86_64-linux = {
  #   vmware = nixos-generators.nixosGenerate {
  #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
  #     modules = [
  #       # you can include your own nixos configuration here, i.e.
  #       # ./configuration.nix
  #     ];
  #     format = "vmware";
  #   };
  #   vbox = nixos-generators.nixosGenerate {
  #     pkgs = nixpkgs.legacyPackages.x86_64-linux;
  #     format = "virtualbox";
  #   };
  # };
}
