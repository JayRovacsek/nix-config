{ self }: {
  base-users = import ./base-users.nix { inherit self; };
  colour-schemes = import ./colour-schemes { inherit self; };
  dotnet-packages = builtins.attrNames (builtins.readDir ../packages/dotnet);
  home-manager = import ./home-manager.nix { inherit self; };
  home-manager-module-sets = import ./home-manager-sets { inherit self; };
  home-manager-modules =
    builtins.attrNames (builtins.readDir ../home-manager-modules);
  headscale = import ./headscale.nix { inherit self; };
  images = import ./images { inherit self; };
  keys = import ./keys.nix { inherit self; };
  metadata = import ./metadata.nix { inherit self; };
  minimal-modules = import ./minimal-modules.nix { inherit self; };
  modules = import ./modules.nix { inherit self; };
  nixos-modules = builtins.attrNames (builtins.readDir ../modules);
  networking = import ./networking.nix { };
  node-packages = builtins.attrNames (builtins.readDir ../packages/node);
  overlays = import ./overlays.nix { inherit self; };
  go-packages = builtins.attrNames (builtins.readDir ../packages/go);
  options = import ./options.nix { inherit self; };
  package-sets = import ./package-sets.nix { inherit self; };
  python-packages = builtins.attrNames (builtins.readDir ../packages/python);
  rust-packages = builtins.attrNames (builtins.readDir ../packages/rust);
  resource-packages =
    builtins.attrNames (builtins.readDir ../packages/resources);
  shell-packages = builtins.attrNames (builtins.readDir ../packages/shell);
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  stylix = import ./stylix.nix { inherit self; };
  system = import ./system.nix { inherit self; };
  tailscale = import ./tailscale.nix { inherit self; };
  text-packages = builtins.attrNames (builtins.readDir ../packages/text);
  tofu = import ./tofu { inherit self; };
  tofu-stacks = import ./tofu-stacks.nix { inherit self; };
  topology = import ./topology.nix { inherit self; };
  user-attr-names = import ./user-attr-names.nix { };
  users = import ./users.nix { inherit self; };
}
