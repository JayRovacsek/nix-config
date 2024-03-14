_: {
  imports =
    [ ./hardware-configuration.nix ./modules.nix ./system-packages.nix ];

  networking = {
    hostId = "4148aee3";
    hostName = "ninetales";
  };

  boot = {
    kernelBuildIsCross = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };

  nixpkgs.config.allowUnsupportedSystem = true;
}
