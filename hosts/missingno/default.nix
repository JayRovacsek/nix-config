{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (self.lib) merge;

  builder = self.common.users.builder {
    inherit config pkgs;
    modules = self.common.home-manager-module-sets.base;
  };

  jay = self.common.users.jay {
    inherit config pkgs;
    modules =
      (with self.common.home-manager-module-sets; hyprland-ironbar-desktop ++ ssh ++ ai)
      ++ (with self.homeManagerModules; [
        chromium
      ]);
  };

  user-configs = merge [
    builder
    jay
  ];
in
{
  inherit (user-configs) users home-manager;

  imports =
    (with self.nixosModules; [
      ../../modules/hardware/strix-halo
      ./disk-config.nix
      agenix
      alloy
      amd-gpu
      bluetooth
      clamav
      fonts
      generations
      gnome-keyring
      gnupg
      greetd
      halogen-flash-server
      home-manager
      hyprland
      i18n
      # impermanence
      # laya
      lanzaboote-edk2-shell
      lix
      logging
      lorri
      nix
      nix-topology
      # nvidia
      openssh
      # pipewire
      # playstation-controller
      remote-builds
      ssh
      steam
      sudo
      systemd-boot
      systemd-networkd
      time
      timesyncd
      tmp-tmpfs
      tmux
      tuned-accelerator-performance
      udev
      # zramSwap
      zsh
    ])
    ++ (with self.inputs; [
      lanzaboote.nixosModules.lanzaboote
      nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
    ]);

  age.identityPaths = [ "/agenix/id-ed25519-${config.networking.hostName}-primary" ];

  boot = {
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    # amdgpu comes from the amd-gpu module.
    kernelModules = [
      "kvm-amd"
    ];

    # https://offsite.guru/blog/halogen-strix-halo/
    kernelPackages = pkgs.linuxPackages_7_2;

    lanzaboote = {
      enable = true;
      autoEnrollKeys.enable = true;
      autoGenerateKeys.enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    loader.systemd-boot.enable = lib.mkForce false;

    supportedFilesystems = [
      "ntfs"
    ];
  };

  environment = {
    # ROCm/graphics environment variables and packages come from the
    # amd-gpu and hardware/strix-halo modules; only host-specific values
    # are set here.
    sessionVariables.WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:c3:00.0-card";

    systemPackages = with pkgs; [
      agenix
      curl
      dua
      sbctl
      dig
    ];
  };

  # fileSystems come from disk-config.nix via disko.

  hardware = {
    # enableRedistributableFirmware and the graphics stack come from the
    # amd-gpu module.
    amd-gpu.hsaOverrideGfxVersion = "11.5.1";

    cpu = {
      amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      profile = {
        cores = 16;
        speed = 20;
      };
    };
  };

  networking = {
    hostId = "ef26b1be";
    hostName = "missingno";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  programs = {
    fuse.userAllowOther = true;
    ssh.publicHostKeyBase64 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpmTTNFb1BjMU9PME5EemdTeFo0dndmSEZrM0FiYjUwS2x5NDdjVXJOeFggcm9vdEBhbGFrYXphbQo=";
  };

  remoteBuilds = lib.mkForce {
    machineConfigs = [
      {
        hostName = "dragonite.local";
        maxJobs = 24;
        protocol = "ssh-ng";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVBWa1lSQVZjWTVNc1RzdGlMT2xHaDhmTlN1TW9UUzJYRHdwQ1h4QkUydjEgcm9vdEBkcmFnb25pdGUK";
        speedFactor = 48;
        sshUser = "builder";
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      }
    ];
  };

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    };

    pulseaudio.enable = false;

    # videoDrivers comes from the amd-gpu module.
    xserver.enable = true;
  };

  system.stateVersion = "26.05";

  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };

  virtualisation.docker.enable = true;
}
