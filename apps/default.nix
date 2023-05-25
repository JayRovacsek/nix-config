{ self, system }:
let
  inherit (self.lib) merge;

  # Previously I had configured this to evaluate at system evaluation time.
  # this is costly as heck when more machines, so this should give an escape
  # hatch to generate a suitable JSON blob that can be stored and regenerated
  # easily to enable much faster evaluation of the configuration at build times.
  distributed-builds = import ./distributed-builds.nix { inherit self system; };

  nixinate = import ./nixinate.nix { inherit self system; };
  terraform = import ./terraform.nix { inherit self system; };

in merge [ distributed-builds nixinate terraform ]
