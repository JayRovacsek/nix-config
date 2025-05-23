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

  extend-host =
    cfg: name:
    let
      modules = [ ../hosts/${name} ];
      specialArgs = {
        inherit self;
      };
    in
    cfg.extendModules {
      inherit
        modules
        specialArgs
        ;
    };

  make-host =
    package-set: name: system-builder:
    let
      inherit (package-set) system identifier pkgs;
      modules = self.common.modules.${identifier} ++ [ ../hosts/${name} ];
      specialArgs = {
        inherit self;
      };
    in
    system-builder {
      inherit
        modules
        pkgs
        specialArgs
        system
        ;
    };

  make-minimal-microvm =
    package-set: system-builder:
    let
      inherit (package-set) system identifier pkgs;
      modules = self.common.minimal-modules.${identifier};
      specialArgs = {
        inherit self;
      };
    in
    system-builder {
      inherit
        modules
        pkgs
        specialArgs
        system
        ;
    };

  make-microvm =
    package-set: name: system-builder:
    let
      base = make-minimal-microvm package-set system-builder;
    in
    base.extendModules { modules = [ ../hosts/${name} ]; };

in
{
  inherit
    extend-host
    make-host
    make-microvm
    make-minimal-microvm
    ;
}
