{ config, pkgs, ... }: {
  # Share hosts nix store as readonly
  microvm = {
    shares = [{
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];

    # Disable the ability to write to the guests store at all
    writableStoreOverlay = null;

    hypervisor = pkgs.qemu;

    nixosModules.host = config.system.name;
  };
}
