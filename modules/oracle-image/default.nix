{ modulesPath, ... }: {
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    efiInstallAsRemovable = false;
  };

  networking.usePredictableInterfaceNames = false;
  networking.interfaces.eth0.useDHCP = true;
}
