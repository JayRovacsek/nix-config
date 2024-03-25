{ config, pkgs, lib, modulesPath, self, ... }:

let
  inherit (self) common;
  inherit (self.common.home-manager-module-sets) base hyprland-desktop-minimal;
  inherit (self.lib) merge;

  builder = common.users.builder {
    inherit config pkgs;
    modules = base;
  };

  jay = common.users.jay {
    inherit config pkgs;
    modules = hyprland-desktop-minimal
      ++ (with self.homeManagerModules; [ mako waybar ]);
  };

  user-configs = merge [ builder jay ];

in {
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    agenix
    generations
    gnupg
    greetd
    hyprland
    lorri
    nix
    openssh
    self.inputs.nixos-hardware.nixosModules.raspberry-pi-4
    sudo
    systemd-networkd
    time
    timesyncd
    zsh
  ];

  age = {
    identityPaths = [
      "/agenix/id-ed25519-ssh-primary"
      "/agenix/id-ed25519-wireless-primary"
    ];

    secrets."wireless.env" = {
      file = ../../secrets/wireless/wireless-iot.env.age;
      mode = "0400";
      symlink = false;
    };
  };

  boot = {
    # VC4 required for GPU hardware acceleration
    initrd.availableKernelModules = [
      "pcie_brcmstb"
      "reset-raspberrypi"
      "usb_storage"
      "usbhid"
      "vc4"
      "xhci_pci"
    ];

    # Set the headphone jack as the default output
    extraModprobeConfig = ''
      options snd_bcm2835 enable_headphones=1
    '';

    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "cma=256M"
      "console=tty1"
      "console=ttyAMA0,115200"
      "8250.nr_uarts=1"
      "kunit.enable=0"
    ];
  };

  environment.systemPackages = with pkgs; [ alacritty jellyfin-media-player ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  hardware = {
    # Filter for just pi4 replated device drivers
    deviceTree.filter = "bcm2711-rpi-4*.dtb";

    # Audio settings to ensure the headphones are the default
    pulseaudio = {
      enable = true;
      # Default to the 3.5mm jack as output
      extraConfig = ''
        set-default-sink alsa_output.platform-bcm2835_audio.stereo-fallback.2
      '';
      package = pkgs.pulseaudioFull;
    };

    raspberry-pi."4" = {
      # Enable GPU acceleration
      fkms-3d = {
        enable = true;
        cma = 1024;
      };
    };
  };

  networking = {
    hostName = "wigglytuff";
    hostId = "d2a7b80b";
    wireless = {
      enable = true;
      environmentFile = config.age.secrets."wireless.env".path;
      interfaces = [ "wlan0" ];
      networks."@SSID@".psk = "@PSK@";
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  services = {
    journald.storage = "volatile";
    # Hide Builder user from SDDM login
    xserver.displayManager.sddm.settings.Users.HideUsers = "builder";
    timesyncd.servers = lib.mkForce [
      # "129.6.15.28"
      "137.92.140.80" # -> ntp.ise.canberra.edu.au
      "138.194.21.154" # -> ntp.mel.nml.csiro.au
      "129.6.15.28" # -> time-a-g.nist.gov
      "129.6.15.29" # -> time-b-g.nist.gov
    ];
  };

  swapDevices = [{
    device = "/swapfile";
    size = 3072;
  }];

  system.stateVersion = "24.05";
}
