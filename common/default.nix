{ self }:
let
  inherit (self.inputs.nixpkgs) lib;

  readPackageDirectory =
    dir:
    builtins.attrNames (
      lib.filterAttrs (n: v: v == "directory" && builtins.pathExists (dir + "/${n}/default.nix")) (
        builtins.readDir dir
      )
    );
in
{
  base-users = import ./base-users.nix { inherit self; };
  colour-schemes = import ./colour-schemes { inherit self; };
  config = import ./config.nix { inherit self; };
  dotnet-packages = readPackageDirectory ../packages/dotnet;
  home-manager = import ./home-manager.nix { inherit self; };
  home-manager-module-sets = import ./home-manager-sets { inherit self; };
  home-manager-modules = builtins.attrNames (builtins.readDir ../home-manager-modules);
  images = import ./images { inherit self; };
  keys = import ./keys.nix { inherit self; };
  metadata = import ./metadata.nix { inherit self; };
  minimal-modules = import ./minimal-modules.nix { inherit self; };
  modules = import ./modules.nix { inherit self; };
  nixos-modules = builtins.attrNames (builtins.readDir ../modules);
  nixpkgs-config = import ./nixpkgs-config.nix { inherit self; };
  overlays = import ./overlays.nix { inherit self; };
  go-packages = readPackageDirectory ../packages/go;
  options = import ./options.nix { inherit self; };
  package-sets = import ./package-sets.nix { inherit self; };
  python-packages = readPackageDirectory ../packages/python;
  rust-packages = readPackageDirectory ../packages/rust;
  resource-packages = readPackageDirectory ../packages/resources;
  sboms = self.lib.sbom.mkAllHostSboms self.nixosConfigurations;
  shell-packages = readPackageDirectory ../packages/shell;
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  stylix = import ./stylix.nix { inherit self; };
  system = import ./system.nix { inherit self; };
  text-packages = readPackageDirectory ../packages/text;
  tofu = import ./tofu { inherit self; };
  tofu-stacks = import ./tofu-stacks.nix { inherit self; };
  topology = import ./topology.nix { inherit self; };
  user-attr-names = import ./user-attr-names.nix { };
  users = import ./users.nix { inherit self; };
}
