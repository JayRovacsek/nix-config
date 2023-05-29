{ self }:
let
  inherit (self.lib) distributed-builds;

  extended = { distributed-builds = distributed-builds.base-configs; };

in { inherit extended; }
