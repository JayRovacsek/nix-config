{
  config,
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
      hyprland-ironbar-desktop ++ games ++ ssh;
  };

  user-configs = merge [
    builder
    jay
  ];

in
{
  inherit (user-configs) users home-manager;

  imports = with self.nixosModules; [
    agenix
    clamav
    fonts
    generations
    gnome-keyring
    gnupg
    grafana-agent
    greetd
    home-manager
    hyprland
    i18n
    keybase
    lix
    logging
    lorri
    microvm-host
    nextcloud-client
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
    tailscale
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
      "/agenix/id-ed25519-terraform-primary"
    ];

    secrets = {
      git-signing-key = rec {
        file = ../../secrets/ssh/git-signing-key.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key";
      };

      "git-signing-key.pub" = rec {
        file = ../../secrets/ssh/git-signing-key.pub.age;
        owner = builtins.head (builtins.attrNames jay.users.users);
        path = "/home/${owner}/.ssh/git-signing-key.pub";
      };

      tailnet-preauth.file = ../../secrets/tailscale/preauth-admin.age;
    };
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
      luks.devices.crypted = {
        device = "/dev/disk/by-uuid/7cf02c33-9404-45af-9e53-2fa65aa59027";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
    ];
  };

  environment.systemPackages = with pkgs; [
    agenix
    curl
    dig
    r2modman
    trdsql
    wget
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e78b4f61-9844-4cb3-a144-ff8f8dd37154";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3BA7-CA2B";
    fsType = "vfat";
  };

  hardware.cpu = {
    profile = {
      cores = 8;
      speed = 2;
    };
    intel.updateMicrocode = true;
  };

  networking = {
    hostId = "ef26b1be";
    hostName = "alakazam";
  };

  programs.ssh.publicHostKeyBase64 = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUFkcjVkaW9UeTNtTUs3VGpydUxid2tnMENLYWJ3TTVXT2VyckdJNC9MM1cgcm9vdEBhbGFrYXphbQo=";

  system.stateVersion = "22.11";

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
