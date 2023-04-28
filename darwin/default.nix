{ self }:
let

  inherit (self.common.system) stable-darwin-system unstable-darwin-system;

  inherit (self.common.package-sets)
    aarch64-darwin-unstable x86_64-darwin-stable;
in {
  # Hosts
  cloyster = let
    inherit (x86_64-darwin-stable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/cloyster ];
  in stable-darwin-system { inherit system pkgs modules; };

  ninetales = let
    inherit (aarch64-darwin-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/ninetales ];
  in unstable-darwin-system { inherit system pkgs modules; };

  victreebel = let
    inherit (aarch64-darwin-unstable) system identifier pkgs;
    base = self.common.modules.${identifier};
    modules = base ++ [ ../hosts/victreebel ];
  in unstable-darwin-system { inherit system pkgs modules; };
}
