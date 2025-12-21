{ pkgs, self, ... }:
{
  imports = [ self.inputs.lix-module.nixosModules.default ];

  nixpkgs.overlays = [
    (_final: prev: {
      inherit (prev.lixPackageSets.stable)
        nix-eval-jobs
        nix-fast-build
        nixpkgs-direnv
        nixpkgs-review
        ;
    })
  ];

  nix.package = pkgs.lixPackageSets.stable.lix;
}
