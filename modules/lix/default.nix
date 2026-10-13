{
  pkgs,
  self,
  ...
}:
{
  imports = [ self.inputs.nix-monitored.darwinModules.default ];

  nixpkgs.overlays = [
    (final: prev: {
      nix-monitored = self.inputs.nix-monitored.packages.aarch64-darwin.default.override {
        nix = final.lixPackageSets.latest.lix;
        withNotify = pkgs.stdenv.isLinux;
      };
      nixos-rebuild = prev.nixos-rebuild.override {
        nix = final.nix-monitored;
      };
      nix-direnv = prev.nix-direnv.override {
        nix = final.nix-monitored;
      };
    })
  ];

  nix.package = self.inputs.nix-monitored.packages.aarch64-darwin.default.override {
    nix = pkgs.lixPackageSets.latest.lix;
    withNotify = pkgs.stdenv.isLinux;
  };
}
