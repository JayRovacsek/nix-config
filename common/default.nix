{ self }: {
  inherit self;

  age = import ./age.nix { inherit self; };
  base-users = import ./base-users.nix { inherit self; };
  colour-schemes = import ./colour-schemes { inherit self; };
  cloud-base-image-modules =
    import ./cloud-base-image-modules { inherit self; };
  dotnet-modules =
    builtins.attrNames (builtins.readDir ../packages/dotnet-modules);
  fonts = import ./fonts.nix { inherit self; };
  generations = import ./generations.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  home-manager-module-sets = import ./home-manager-sets { inherit self; };
  home-manager-modules = import ./home-manager-modules.nix { inherit self; };
  headscale = import ./headscale.nix { inherit self; };
  hyprland = import ./hyprland.nix { inherit self; };
  impermanence = import ./impermanence.nix { inherit self; };
  i18n = import ./i18n.nix { inherit self; };
  images = import ./images { inherit self; };
  metadata = import ./metadata.nix { inherit self; };
  microvm = import ./microvm.nix { inherit self; };
  modules = import ./modules.nix { inherit self; };
  node-modules = builtins.attrNames (builtins.readDir ../packages/node-modules);
  go-modules = builtins.attrNames (builtins.readDir ../packages/go-modules);
  nixified-ai = import ./nixified-ai.nix { inherit self; };
  options = import ./options.nix { inherit self; };
  package-sets = import ./package-sets.nix { inherit self; };
  pre-commit-unsupported = import ./pre-commit-unsupported.nix;
  python-modules =
    builtins.attrNames (builtins.readDir ../packages/python-modules);
  self-reference = import ./self-reference.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  stylix = import ./stylix.nix { inherit self; };
  system = import ./system.nix { inherit self; };
  tailscale = import ./tailscale.nix { inherit self; };
  terraform = import ./terraform { inherit self; };
  terraform-stacks = import ./terraform-stacks.nix { inherit self; };
  user-attr-names = import ./user-attr-names.nix { };
  users = import ./users.nix { inherit self; };
}
