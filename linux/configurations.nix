{ nixpkgs, overlays, home-manager, extraModules ? { }, darwin ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;

  nixos-hardware = builtins.getAttr "nixos-hardware" extraModules;
  microvm = builtins.getAttr "microvm" extraModules;

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
      extraModules = [ microvm.nixosModules.host ];
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
      hostname = "jigglypuff";
      extraModules = [ nixos-hardware.nixosModules.raspberry-pi-4 ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };
}
