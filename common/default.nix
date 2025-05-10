{ self }:
let
  inherit (self.inputs.nixpkgs) lib;

  read-package-directory =
    dir:
    builtins.attrNames (
      lib.filterAttrs (
        n: v:
        v == "directory"
        && (builtins.hasAttr "default.nix" (builtins.readDir "${dir}/${n}"))
      ) (builtins.readDir dir)
    );
in
{
  base-users = import ./base-users.nix { inherit self; };
  colour-schemes = import ./colour-schemes { inherit self; };
  config = import ./config.nix { inherit self; };
  dotnet-packages = read-package-directory ../packages/dotnet;
  home-manager = import ./home-manager.nix { inherit self; };
  home-manager-module-sets = import ./home-manager-sets { inherit self; };
  home-manager-modules = builtins.attrNames (
    builtins.readDir ../home-manager-modules
  );
  images = import ./images { inherit self; };
  keys = import ./keys.nix { inherit self; };
  metadata = import ./metadata.nix { inherit self; };
  minimal-modules = import ./minimal-modules.nix { inherit self; };
  modules = import ./modules.nix { inherit self; };
  nixos-modules = builtins.attrNames (builtins.readDir ../modules);
  node-packages = read-package-directory ../packages/node;
  overlays = import ./overlays.nix { inherit self; };
  go-packages = read-package-directory ../packages/go;
  options = import ./options.nix { inherit self; };
  package-sets = import ./package-sets.nix { inherit self; };
  python-packages = read-package-directory ../packages/python;
  rust-packages = read-package-directory ../packages/rust;
  resource-packages = read-package-directory ../packages/resources;
  shell-packages = read-package-directory ../packages/shell;
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  stylix = import ./stylix.nix { inherit self; };
  system = import ./system.nix { inherit self; };
  text-packages = read-package-directory ../packages/text;
  tofu = import ./tofu { inherit self; };
  tofu-stacks = import ./tofu-stacks.nix { inherit self; };
  topology = import ./topology.nix { inherit self; };
  user-attr-names = import ./user-attr-names.nix { };
  users = import ./users.nix { inherit self; };
}
