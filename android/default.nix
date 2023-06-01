{ self }:
let
  inherit (self.inputs.nixpkgs) lib;
  inherit (self.inputs.robotnix.lib) robotnixSystem;
in lib.mapAttrs (_name: robotnixSystem) {
  rapidash = import ../hosts/rapidash/default.nix;
}
