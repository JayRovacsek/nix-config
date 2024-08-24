{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) hyprland-ironbar-desktop;

  inherit (self.lib) merge;

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-ironbar-desktop;
  };

  user-configs = merge [ jay ];

in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    agenix
    clamav
    grafana-agent
    nix-topology
    fonts
    generations
    gnupg
    greetd
    grub
    hyprland
    i18n
    lorri
    nix
    openssh
    pipewire
    steam
    systemd-networkd
    time
    timesyncd
    udev
    zramSwap
    zsh
  ];

  age = {
    secrets = {
      "git-signing-key" = rec {
        file = ../../secrets/ssh/git-signing-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = rec {
        file = ../../secrets/ssh/git-signing-key.pub.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key.pub";
      };

      "terraform-api-key" = rec {
        file = ../../secrets/terraform/terraform-api-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        mode = "400";
        path = "/home/${owner}/.terraform.d/credentials.tfrc.json";
      };

      "wireless.env" = {
        file = ../../secrets/wireless/wireless-home.env.age;
        mode = "0400";
      };
    };
    identityPaths = [
      "/agenix/id-ed25519-ssh-primary"
      "/agenix/id-ed25519-terraform-primary"
      "/agenix/id-ed25519-wireless-primary"
    ];
  };

  boot = {
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/21c13271-a27f-4106-87bb-2ec4c2a043dc";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];

    loader.efi.canTouchEfiVariables = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    agenix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6fa51786-dfec-48eb-9380-559d3980da5c";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4D3E-FB0A";
      fsType = "vfat";
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "gastly";
    wireless = {
      enable = true;
      environmentFile = config.age.secrets."wireless.env".path;
      interfaces = [ "wlp58s0" ];
      networks."@SSID@" = {
        psk = "@PSK@";
        priority = 10;
        authProtocols = [ "WPA-PSK" ];
      };
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/907b7556-218a-4516-ae2b-0b310d6b0b19";
      priority = 1;
    }
  ];

  system.stateVersion = "22.11";
}
