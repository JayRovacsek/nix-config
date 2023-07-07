{ self }: {
  certificates = import ./certificates.nix { inherit self; };
  distributed-builds = import ./distributed-builds.nix { inherit self; };
  generators = import ./generators.nix { inherit self; };
  github = import ./github.nix { inherit self; };
  hostnames = import ./hostnames.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  hyprland = import ./hyprland.nix { inherit self; };
  intersect-multiple-lists =
    import ./intersect-multiple-lists.nix { inherit self; };
  merge = import ./merge.nix { inherit self; };
  microvm = import ./microvm.nix { inherit self; };
  ssh = import ./ssh.nix { inherit self; };
  standardise-nix = import ./standardise-nix.nix { inherit self; };
  tailscale = import ./tailscale.nix { inherit self; };
  users = import ./users.nix { inherit self; };
}
