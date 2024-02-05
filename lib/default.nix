{ self }: {
  authelia = import ./authelia.nix { inherit self; };
  certificates = import ./certificates.nix { inherit self; };
  distributed-builds = import ./distributed-builds.nix { inherit self; };
  docker = import ./docker.nix { inherit self; };
  etc = import ./etc.nix { inherit self; };
  generators = import ./generators.nix { inherit self; };
  github = import ./github.nix { inherit self; };
  host = import ./host.nix { inherit self; };
  hostnames = import ./hostnames.nix { inherit self; };
  home-manager = import ./home-manager.nix { inherit self; };
  hydra = import ./hydra.nix { inherit self; };
  hyprland = import ./hyprland.nix { inherit self; };
  intersect-multiple-lists =
    import ./intersect-multiple-lists.nix { inherit self; };
  merge = import ./merge.nix { inherit self; };
  nginx = import ./nginx { inherit self; };
  microvm = import ./microvm.nix { inherit self; };
  options = import ./options.nix { inherit self; };
  ssh = import ./ssh.nix { inherit self; };
  tailscale = import ./tailscale.nix { inherit self; };
  terraform = import ./terraform.nix { inherit self; };
  users = import ./users.nix { inherit self; };
}
