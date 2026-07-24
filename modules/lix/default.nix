{
  pkgs,
  self,
  ...
}:
{
  imports = [ self.nixosModules.nix-monitored ];

  nixpkgs.overlays = [
    (final: prev: {
      nix-monitored = prev.nix-monitored.override {
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

  nix.package = pkgs.nix-monitored;
}
