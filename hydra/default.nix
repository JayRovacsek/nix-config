{ self, lib }:
let
  inherit (lib) filterAttrs mapAttrs;

  unsupported-systems = [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
  # Strip out unsupportable systems.
  supported-packages = builtins.removeAttrs self.packages unsupported-systems;

  unsupported-configurations = [
    "amazon"
  ];

  problematic-packages = [
    "amazon"
    "linode-ami"
    "linode"
    "oracle-aarch64"
    "oracle-x86_64"
    "oracle"
    "rpi4-sdImage"
    "rpi5-sdImage"
  ];

  # Strip items that hydra just cannot handle
  non-problematic-packages = mapAttrs (
    _: value: builtins.removeAttrs value problematic-packages
  ) supported-packages;

  # Strip broken & unsupported packages as they just cause eval errors
  non-broken-packages = mapAttrs (
    _: value:
    filterAttrs (
      _: v: (!(v.meta.broken or false) && !(v.meta.unsupported or false))

    ) value
  ) non-problematic-packages;
in
{
  devShells = removeAttrs self.devShells unsupported-systems;

  # Wrap nixos configuration testing via the system.build.toplevel
  # attribute which which ensure both build suitability as well as
  # create a binary-cache entry for all shared elements.
  #
  # Remove any systems matching the names in unsupported-configurations
  nixosConfigurations = builtins.mapAttrs (_: v: v.config.system.build.toplevel) (
    filterAttrs (
      n: _: !(builtins.elem n unsupported-configurations)
    ) self.nixosConfigurations
  );

  # Strip out below known issue packages when it comes to
  # hydra evaluation.
  packages = non-broken-packages;
}
