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
      # ./disk-config.nix
      ./hw.nix
      ./x.nix
      agenix
      alloy
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
      udev
      # zramSwap
      zsh
    ])
    ++ (with self.inputs; [
      lanzaboote.nixosModules.lanzaboote
      nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
    ]);

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  age.identityPaths = [
    "/agenix/id-ed25519-${config.networking.hostName}-primary"
  ];

  boot = {
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
    lanzaboote = {
      autoEnrollKeys.enable = true;
      autoGenerateKeys.enable = true;
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  boot = {
    loader.systemd-boot.edk2-uefi-shell.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    supportedFilesystems = [
      "ntfs"
    ];
  };

  environment.systemPackages = with pkgs; [
    agenix
    curl
    dua
    sbctl
    dig
  ];

  hardware.cpu.profile = {
    cores = 16;
    speed = 20;
  };

  networking = {
    hostId = "ef26b1be";
    hostName = "missingno";
  };

  programs.fuse.userAllowOther = true;

  programs.ssh.publicHostKeyBase64 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpmTTNFb1BjMU9PME5EemdTeFo0dndmSEZrM0FiYjUwS2x5NDdjVXJOeFggcm9vdEBhbGFrYXphbQo=";

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

  system.stateVersion = "26.05";

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
