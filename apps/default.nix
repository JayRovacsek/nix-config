{ self, pkgs }:
let
  inherit (self.lib) merge;
  act = import ./act.nix { inherit self pkgs; };

  # Previously I had configured this to evaluate at system evaluation time.
  # this is costly as heck when more machines, so this should give an escape
  # hatch to generate a suitable JSON blob that can be stored and regenerated
  # easily to enable much faster evaluation of the configuration at build times.
  distributed-builds = import ./distributed-builds.nix { inherit self pkgs; };

  hydra = import ./hydra.nix { inherit self pkgs; };
  nixci = import ./nixci.nix { inherit self pkgs; };
  tofu = import ./tofu.nix { inherit self pkgs; };

in merge [ act distributed-builds nixci hydra tofu ]
