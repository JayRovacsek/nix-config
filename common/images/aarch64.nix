{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;
in unstable-system rec {
  system = "aarch64-linux";
  pkgs = import nixpkgs { inherit system; };
  modules = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    {
      networking.hostName = "aarch64";
      system.stateVersion = "23.11";
    }
  ];
}
