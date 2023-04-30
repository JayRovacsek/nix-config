{ self }: {
  hyprland = import ./hyprland.nix { inherit self; };
  generate-user-config = import ./generate-user-config.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  intersect-multiple-lists =
    import ./intersect-multiple-lists.nix { inherit self; };
  merge-user-config = import ./merge-user-config.nix { inherit self; };
  microvm = import ./microvm.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  to-css = import ./to-css.nix { inherit self; };
}
