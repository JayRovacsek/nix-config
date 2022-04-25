{ nixpkgs, overlays, home-manager, nixos-hardware ? { } }:
let
  home-manager-function = import ../functions/home-manager.nix;

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
      host = "alakazam";
      isNixos = true;
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
      host = "gastly";
      isNixos = true;
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
      host = "dragonite";
      isNixos = true;
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
      host = "ninetales";
      isNixos = true;
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
      host = "jigglypuff";
      isNixos = true;
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
      host = "jigglypuff";
      isNixos = true;
      extraModules = [ nixos-hardware.nixosModules.raspberry-pi-4 ];
    };
  in nixpkgs.lib.nixosSystem {
    inherit system;
    inherit pkgs;
    inherit modules;
  };
}
