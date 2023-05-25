{ self }: {
  distributed-builds = import ./distributed-builds.nix { inherit self; };
  generate-user-config = import ./generate-user-config.nix { inherit self; };
  github = import ./github.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  hyprland = import ./hyprland.nix { inherit self; };
  intersect-multiple-lists =
    import ./intersect-multiple-lists.nix { inherit self; };
  merge = import ./merge.nix { inherit self; };
  microvm = import ./microvm.nix { inherit self; };
  ssh = import ./ssh.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  to-css = import ./to-css.nix { inherit self; };
}
