{ self }:
let

  # Wrap common boilerplate for system definitions into a single function.
  # package-set should be an attr akin to:
  # {
  #   identifier = "ARCH-FAMILY-IDENTIFIER"
  #   pkgs = NIXPKGS; 
  #   system = NIXPKGS-IDENTIFIER
  # }
  # 
  # As an example for unstable x86_64 linux:
  # {
  #   identifier = "x86_64-linux-unstable"
  #   pkgs = NIXPKGS; 
  #   system = "x86_64-linux"
  # }
  #  
  # Name should refer to what folder the system lives in within the hosts
  # folder (and commonly applied as that system's hostname etc)
  # system-builder should be a function to build a system such as 
  # pkgs.lib.nixosSystem
  # or from nix-darwin:
  # pkgs.lib.darwinSystem

  make-host = package-set: name: system-builder:
    let
      inherit (package-set) system identifier pkgs;
      base = self.common.modules.${identifier} ++ [ ../hosts/${name} ];
      extra-modules = import ../hosts/${name}/modules.nix { inherit self; };
      modules = base ++ extra-modules;
    in system-builder { inherit system pkgs modules; };

  make-microvm = package-set: name: system-builder:
    let
      inherit (package-set) system identifier pkgs;
      base = self.common.minimal-modules.${identifier} ++ [ ../hosts/${name} ];
      extra-modules = import ../hosts/${name}/modules.nix { inherit self; };
      modules = base ++ extra-modules;
    in system-builder { inherit system pkgs modules; };

in { inherit make-host make-microvm; }
