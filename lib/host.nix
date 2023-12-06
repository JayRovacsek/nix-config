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

  mkHost = { package-set, name, builder, extra-modules ? [ ] }:
    let
      inherit (package-set) system identifier pkgs;
      base = self.common.modules.${identifier} ++ [ ../hosts/${name} ];
      host-modules = import ../hosts/${name}/modules.nix { inherit self; };
      modules = base ++ host-modules ++ extra-modules;
    in builder { inherit system pkgs modules; };
in { inherit mkHost; }
