{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  inherit (self.lib) merge;

  inherit (pkgs) system;
  inherit (self.packages.${system}) trdsql;

  builder = self.common.users.builder {
    inherit config pkgs;
    modules = self.common.home-manager-module-sets.base;
  };

  jay = self.common.users.jay {
    inherit config pkgs;
    modules =
      with self.common.home-manager-module-sets;
      hyprland-ironbar-desktop ++ games ++ ssh ++ impermanence;
  };

  user-configs = merge [
    builder
    jay
  ];
in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    ./disk-config.nix
    agenix
    alloy
    bluetooth
    clamav
    fonts
    generations
    gnome-keyring
    gnupg
    greetd
    home-manager
    hyprland
    i18n
    impermanence
    lix
    logging
    lorri
    nix
    nix-monitored
    nix-topology
    nvidia
    openssh
    pipewire
    remote-builds
    ssh
    steam
    systemd-boot
    systemd-networkd
    time
    timesyncd
    tmp-tmpfs
    tmux
    udev
    zramSwap
    zsh
  ];

  age = {
    identityPaths = [
      "/agenix/id-ed25519-${config.networking.hostName}-primary"
    ];

    secrets.tailnet-preauth.file = ../../secrets/tailscale/preauth-admin.age;
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };

  environment.systemPackages = with pkgs; [
    agenix
    curl
    dig
    trdsql
    wget
  ];

  hardware = {
    cpu = {
      profile = {
        cores = 8;
        speed = 2;
      };
      intel.updateMicrocode = true;
    };
    # System uses a 1060 - so not recommended to use open modules
    nvidia.open = lib.mkForce false;
  };

  networking = {
    hostId = "ef26b1be";
    hostName = "alakazam";
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

  system.stateVersion = "22.11";

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
