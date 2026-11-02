{
  config,
  pkgs,
  self,
  ...
}:

let
  jynx = self.common.users.jynx {
    inherit config pkgs;
    modules = with self.common.home-manager-module-sets; base;
    #  ++ impermanence;
  };
in
{
  inherit (jynx) users home-manager;

  imports = with self.nixosModules; [
    ./disk-config.nix
    agenix
    generations
    home-manager
    i18n
    # impermanence
    kde-big-picture
    nix
    nvidia
    openssh
    pulse-eight-cec
    sudo
    time
    timesyncd
    tmp-tmpfs
    zramSwap
    zsh
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    cpu = {
      profile = {
        cores = 8;
        speed = 2;
      };
      intel.updateMicrocode = true;
    };
  };

  kde-big-picture.autoLoginUser = "jynx";

  networking.hostName = "jynx";

  powerManagement.enable = false;

  system.stateVersion = "26.05";
}
