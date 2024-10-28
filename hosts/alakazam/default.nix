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
    bluetooth
    # Currently broken
    # clamav
    fonts
    generations
    gnome-keyring
    gnupg
    grafana-agent
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
    # May also be broken
    # tailscale
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

  programs.fuse.userAllowOther = true;

  programs.ssh.publicHostKeyBase64 = "YWxha2F6YW0ubG9jYWwgc3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUFkcjVkaW9UeTNtTUs3VGpydUxid2tnMENLYWJ3TTVXT2VyckdJNC9MM1cK";

  system.stateVersion = "22.11";

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
}
