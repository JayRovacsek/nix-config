{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (self.lib) distributed-builds;
  inherit (self) darwinConfigurations nixosConfigurations;

  darwin-host-identifiers = lib.attrNames darwinConfigurations;
  host-identifiers = darwin-host-identifiers ++ linux-host-identifiers;
  linux-host-identifiers = lib.attrNames nixosConfigurations;

  extended = { distributed-builds = distributed-builds.base-configs; };

in {
  inherit darwin-host-identifiers extended host-identifiers
    linux-host-identifiers;
}
