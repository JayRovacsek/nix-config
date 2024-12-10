{ self }:
let
  inherit (self.inputs) nixpkgs;
  inherit (self.common.system) unstable-system;

  inherit (self.common.package-sets) aarch64-linux-unstable;
  inherit (aarch64-linux-unstable) system identifier pkgs;

  modules = self.common.modules.${identifier} ++ [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    self.nixosModules.raspberry-pi-5
    {
      networking.hostName = "rpi5";

      # As we are only ever building this via binfmt allocations
      # disable compression as the performance of achieving compression is
      # not worth the few GB of disk savings at best
      sdImage.compressImage = false;

      system.stateVersion = "24.11";
    }
  ];

  specialArgs = {
    inherit self;
  };
in
unstable-system {
  inherit
    modules
    pkgs
    specialArgs
    system
    ;
}
