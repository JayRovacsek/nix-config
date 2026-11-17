{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  jynx = self.common.users.jynx {
    inherit config pkgs;
    modules = with self.common.home-manager-module-sets; plasma-desktop;
  };
in
{
  age = {
    secrets.wireless-env = {
      file = ../../secrets/wireless/wireless-home.env.age;
      mode = "0400";
      owner = config.users.users.wpa_supplicant.name;
    };

    identityPaths = [
      "/agenix/id-ed25519-wireless-primary"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  inherit (jynx) users home-manager;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  imports = with self.nixosModules; [
    ./disk-config.nix
    agenix
    generations
    home-manager
    i18n
    bluetooth
    kde-big-picture
    nix
    nvidia
    openssh
    pulse-eight-cec
    systemd-boot
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
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
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
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  kde-big-picture.autoLoginUser = "jynx";

  networking = {
    hostName = "jynx";
    wireless = {
      enable = true;
      secretsFile = config.age.secrets.wireless-env.path;
      interfaces = [ "wlp0s20f3" ];
      networks."Ooo Ooo Net" = {
        pskRaw = "ext:PSK";
        priority = 10;
        authProtocols = [ "WPA-PSK" ];
      };
    };
  };

  powerManagement.enable = false;

  system.stateVersion = "26.05";
}
