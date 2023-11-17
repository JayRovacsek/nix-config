{ self }:
let
  # Required build functions
  inherit (self.common.system) darwin-system;

  # Required package-sets
  inherit (self.common.package-sets) aarch64-darwin-unstable;

  inherit (self.lib.host) make-host;
in {
  # Hosts
  ninetales = make-host aarch64-darwin-unstable "ninetales" darwin-system;
  victreebel = make-host aarch64-darwin-unstable "victreebel" darwin-system;
}
