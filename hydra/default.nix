{ self, lib }:
let
  inherit (lib) filterAttrs mapAttrs;

  unsupported-systems = [ "aarch64-darwin" "x86_64-darwin" ];
  # Strip out unsupportable systems.
  supported-packages = builtins.removeAttrs self.packages unsupported-systems;

  # Strip items that hydra just cannot handle
  non-problematic-packages = mapAttrs (_: value:
    builtins.removeAttrs value [
      "amazon"
      "linode"
      "linode-ami"
      "oracle"
      "rpi1-sdImage"
      "rpi2-sdImage"
    ]) supported-packages;

  # Strip broken packages as they just cause eval errors
  non-broken-packages =
    mapAttrs (_: value: filterAttrs (_: v: (!v.meta.broken)) value)
    non-problematic-packages;
in {
  checks = removeAttrs self.checks unsupported-systems;
  devShells = removeAttrs self.devShells unsupported-systems;

  # Wrap nixos configuration testing via the system.build.toplevel 
  # attribute which which ensure both build suitability as well as
  # create a binary-cache entry for all shared elements.
  nixosConfigurations = builtins.mapAttrs (_: v: v.config.system.build.toplevel)
    self.nixosConfigurations;

  # Strip out below known issue packages when it comes to 
  # hydra evaluation.
  packages = non-broken-packages;
}
