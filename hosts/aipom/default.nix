{ pkgs, flake, ... }:
let
  inherit (flake.inputs.microvm.nixosModules) microvm;
  inherit (flake) lib;
in {
  config = let
    networking = {
      hostName = "aipom";
      hostId = "0f5cb1b8";
    };
  in {
    inherit networking;

    microvm = {
      vcpu = 1;
      mem = 1024;
      hypervisor = "qemu";
      declaredRunner = pkgs.lib.mkForce pkgs.qemu;
      interfaces = [{
        type = "tap";
        id = "vm-${networking.hostName}-01";
        mac = "00:00:00:00:00:01";
      }];
      writableStoreOverlay = null;
    };

    imports = [
      microvm
      ../../options/systemd
      ../../modules/microvm/guest
      ../../modules/ombi
      ../../modules/time
      ../../modules/timesyncd
    ];

    system.stateVersion = "23.05";
  };
}
