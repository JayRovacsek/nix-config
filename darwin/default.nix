{ self }:
let
  # Required build functions
  inherit (self.common.system) darwin-system;

  # Required package-sets
  inherit (self.common.package-sets) aarch64-darwin-unstable;

  inherit (self.lib.host) mkHost;
in {
  # Hosts
  ninetales = mkHost {
    builder = darwin-system;
    name = "ninetales";
    package-set = aarch64-darwin-unstable;
  };

  victreebel = mkHost {
    builder = darwin-system;
    name = "victreebel";
    package-set = aarch64-darwin-unstable;
  };
}
