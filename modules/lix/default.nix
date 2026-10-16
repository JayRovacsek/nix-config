{
  pkgs,
  self,
  ...
}:
{
  # nix-monitored exposes the same class-agnostic module under both
  # `nixosModules` and `darwinModules`, so one import covers Linux and Darwin.
  imports = [ self.inputs.nix-monitored.nixosModules.default ];

  # Build the package for the host system (notified builds are Linux-only and
  # default accordingly) and drive it with Lix.
  nix.monitored = {
    enable = true;
    package =
      self.inputs.nix-monitored.packages.${pkgs.stdenv.hostPlatform.system}.default.override
        {
          nix = pkgs.lixPackageSets.latest.lix;
        };
  };
}
